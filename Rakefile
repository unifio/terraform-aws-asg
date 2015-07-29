require 'rake'

inputs = {
  'domain'              => 'unif.io',
  'stack_item_label'    => 'terraform',
  'stack_item_fullname' => 'example',
  'ssh_user'            => 'ec2-user',
  'key_name'            => 'example',
  'ami'                 => 'ami-xxxxxx',
  'vpc_id'              => 'vpc-1a2b3c4d',
  'min_size'            => '2',
  'max_size'            => '5',
  'instance_type'       => 't2.small',
  'instance_profile'    => 'terraform',
  'hc_check_type'       => 'ELB',
  'hc_grace_period'     => '300',
  'subnets'             => 'us-east-1a,us-west-1a',
  'load_balancers'      => 'application-elb',
}

task :default => :verify

desc "Verify the stack"
task :verify do

  vars = []
  inputs.each() do |var, value|
    vars.push("-var #{var}=\"#{value}\"")
  end

  ['basic'].each do |stack|
    task_args = {:stack => stack, :args => vars.join(' ')}
    Rake::Task['clean'].execute(Rake::TaskArguments.new(task_args.keys, task_args.values))
    Rake::Task['plan'].execute(Rake::TaskArguments.new(task_args.keys, task_args.values))
  end
end

desc "Remove existing local state if present"
task :clean, [:stack] do |t, args|
  sh "cd examples/#{args['stack']} && rm -fr .terraform *.tfstate*"
end

desc "Create execution plan"
task :plan, [:stack, :args] do |t, args|
  sh "cd examples/#{args['stack']} && terraform get && terraform plan -module-depth=-1 -input=false #{args['args']}"
end
