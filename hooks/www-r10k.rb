require 'sinatra'
require 'json'

# User customization
WORKINGDIR = '/root'
PUPPETFILE_REPO = "git@github.com:rnelson0/puppet-tutorial.git"
hostname   = 'puppet.nelson.va'
port       = 80

set :bind, hostname
set :port, port
set :lock, 'true'

post '/payload' do
  now = Time.now.strftime('%Y%m%d%H%M%S%L')
  GIT_WORK_DIR_PUPPETFILE = File.expand_path("/var/tmp/p_file_repo_#{now}")
  GIT_DIR_PUPPETFILE = "#{GIT_WORK_DIR_PUPPETFILE}/.git"
  GIT_CMD_PUPPETFILE = "git --git-dir=#{GIT_DIR_PUPPETFILE} --work-tree=#{GIT_WORK_DIR_PUPPETFILE}"

  push = JSON.parse(params[:payload])
  logger.info("github json payload: #{push.inspect}")

  repo_name   = push['repository']['name']
  repo_ref    = push['ref']
  br_deleted  = push['deleted']
  br_created  = push['created']
  ref_array   = repo_ref.split("/")
  ref_type    = ref_array[1]
  branchName  = ref_array[2]
  logger.info("repo name = #{repo_name}")
  logger.info("repo ref = #{repo_ref}")
  logger.info("branch = #{branchName}")

  if br_deleted
    if ref_type == "heads"
      logger.info("delete action for #{branchName}")
      deletePuppetfileBranch(branchName)
      cleanup
    else
      logger.info("Ref type is not a branch, but a tag, so no-op")
    end
  end

  if br_created
    if ref_type == "heads"
      logger.info("create action for #{branchName}")
      createPuppetfileBranch(branchName)
      updatePuppetfileModuleRef(repo_name, branchName)
      deployEnv(branchName)
      cleanup
    else
      logger.info("Ref type is not a branch, but a tag, so no-op")
    end
  end

  if !br_created && !br_deleted
    logger.info("modify action for #{branchName}")
    createPuppetfileBranch(branchName)
    updatePuppetfileModuleRef(repo_name, branchName)
    deployModule(repo_name)
    cleanup
  end

end

def deployEnv(branchname)
  deployCmd = "cd #{WORKINGDIR}"
  deployCmd += " && "
  #deployCmd += "cap update_environment -s branchname=#{branchname}"
  deployCmd += "/usr/bin/r10k deploy environment #{branchname} -p"
  `#{deployCmd}`
end

def deployModule(modulename)
  deployCmd = "cd #{WORKINGDIR}"
  deployCmd += " && "
  #deployCmd += "cap deploy_module -s module_name=#{modulename}"
  deployCmd += "/usr/bin/r10k deploy module #{modulename} -p"
  `#{deployCmd}`
end

def createPuppetfileBranch(branchname)
  clonePuppetfileRepo
  checkoutBranch('production')
  fetch_prune_cmd = "#{GIT_CMD_PUPPETFILE} fetch --prune"
  logger.info("createPuppetfileBranch: fetch prune cmd = #{fetch_prune_cmd}")
  `#{fetch_prune_cmd}`
  branch_exists = branchExists(PUPPETFILE_REPO, branchname)
  if(!branch_exists)
    create_branch_cmd = "#{GIT_CMD_PUPPETFILE} checkout -b #{branchname}"
    create_branch_cmd += " && "
    create_branch_cmd += "#{GIT_CMD_PUPPETFILE} push origin #{branchname}"
    `#{create_branch_cmd}`
  end
end

def branchExists(repo, branch)
  # see if branch exists in repo
  git_remote_branch_cmd = "git ls-remote --heads #{repo} | grep #{branch}"
  puts "\n#{git_remote_branch_cmd}\n"
  `#{git_remote_branch_cmd}`
  if($?.success?) # branch already exists, so check it out
    return true
  else
    return false
  end
end

def deletePuppetfileBranch(branchname)
  clonePuppetfileRepo
  checkoutBranch('production')
  delete_remote_cmd = "#{GIT_CMD_PUPPETFILE} push origin :#{branchname}"
  `#{delete_remote_cmd}`
end

def clonePuppetfileRepo
  logger.info("git work dir = #{GIT_WORK_DIR_PUPPETFILE}")
  clone_cmd = "git clone #{PUPPETFILE_REPO} #{GIT_WORK_DIR_PUPPETFILE}"
  `#{clone_cmd}`
end

def checkoutBranch(branchname)
  checkout_branch_cmd = "#{GIT_CMD_PUPPETFILE} checkout #{branchname}"
  logger.info("checkoutBranch: cmd = #{checkout_branch_cmd}")
  `#{checkout_branch_cmd}`
end

def cleanup
  cleanup_cmd = "rm -rf #{GIT_WORK_DIR_PUPPETFILE}"
  `#{cleanup_cmd}`
end

def updatePuppetfileModuleRef(module_name, branchname)

  begin
    checkoutBranch(branchname)
    contents = File.read("#{GIT_WORK_DIR_PUPPETFILE}/Puppetfile")
    logger.info("updatePuppetfileModuleRef: git work dir = #{GIT_WORK_DIR_PUPPETFILE}")
    regex = /mod (["'])#{module_name}\1(.*?)[\n]\s*:ref\s*=>\s*(['"])(\w+|\w+\.\d+\.\d+)\3/m

    new_contents = contents.gsub(regex, """
mod '#{module_name}'\\2
  :ref => '#{branchname}'
""".strip)

    #logger.info("after regex, file contents = #{new_contents}")

    file = File.open("#{GIT_WORK_DIR_PUPPETFILE}/Puppetfile", "w")
    file.write(new_contents)
    file.close()
    #p_file_after_write = `cat #{GIT_WORK_DIR_PUPPETFILE}/Puppetfile`
    #logger.info("\npuppetfile after writing: #{p_file_after_write}")

    commit_msg = "changing :ref for #{module_name} to #{branchname}"
    git_commit_cmd = "#{GIT_CMD_PUPPETFILE}"
    git_commit_cmd += " add #{GIT_WORK_DIR_PUPPETFILE}/Puppetfile"
    git_commit_cmd += " && "
    git_commit_cmd += "#{GIT_CMD_PUPPETFILE}"
    git_commit_cmd += " commit -m \"#{commit_msg}\""
    git_commit_cmd += " && "
    git_commit_cmd += "#{GIT_CMD_PUPPETFILE}"
    git_commit_cmd += " push origin #{branchname}"
    logger.info("executing git commands:\n#{git_commit_cmd}")
    logger.info("")
    commit_result = `#{git_commit_cmd}`
    logger.info("commit results:\n#{commit_result}\n")

  rescue RuntimeError => e
    logger.info("!!! ERROR: " + e.message)
    exit(false)
  end
end
