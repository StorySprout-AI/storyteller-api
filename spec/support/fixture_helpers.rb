# frozen_string_literal: true

def load_task_script(script_name, ext: 'rb')
  load Rails.root.join('lib', 'tasks', "#{script_name}.#{ext}")
end

def load_cli_script(script_name, ext: 'thor')
  load_task_script("story-cli/#{script_name}", ext:)
end
