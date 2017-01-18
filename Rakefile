require 'rake'

inputs = {
  'stack_item_label'    => 'expl-tst',
  'stack_item_fullname' => 'Example Stack',
  'organization'        => 'unifio',
  'vpc_id'              => 'vpc-xxxxxxxx',
  'lan_subnet_ids'      => 'subnet-aaaaaaaa,subnet-bbbbbbbb,subnet-cccccccc',
  'region'              => 'us-west-2',
  'ami'                 => 'ami-xxxxxxxx',
  'instance_type'       => 't2.small',
  'instance_profile'    => 'terraform',
  'key_name'            => 'example',
  'cluster_min_size'    => '4',
  'cluster_max_size'    => '4',
  'min_elb_capacity'    => '2',
  'internal'            => 'true',
  'cross_zone_lb'       => 'true',
  'connection_draining' => 'true'
}

task :default => :verify

desc "Verify the stack"
task :verify do

  vars = []
  inputs.each() do |var, value|
    vars.push("-var #{var}=\"#{value}\"")
  end

  ['basic','standard'].each do |stack|
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
