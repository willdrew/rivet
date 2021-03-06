require_relative './rivet_spec_setup'

include SpecHelpers

describe 'rivet bootstrap' do
  let (:bootstrap) { Rivet::Bootstrap.new(SpecHelpers::AUTOSCALE_DEF['bootstrap']) }
  let (:bootstrap_def) { SpecHelpers::AUTOSCALE_DEF['bootstrap'] }

  tempdir_context 'with all necessary files in place' do
    before do
      FileUtils.mkdir_p bootstrap_def['config_dir']

      validator_file = File.join(
        bootstrap_def['config_dir'],
        "#{bootstrap_def['environment']}-validator.pem")

      FileUtils.touch(validator_file)

      template_dir = File.join(
        bootstrap_def['config_dir'],
        Rivet::Bootstrap::TEMPLATE_SUB_DIR)

      FileUtils.mkdir_p template_dir

      template_file = File.join(template_dir, bootstrap_def['template'])
      File.open(template_file, 'w') { |f| f.write(SpecHelpers::BOOTSTRAP_TEMPLATE) }
    end

    describe "#user_data" do
      it 'returns a string that contains the chef organization' do
        org = bootstrap_def['chef_organization']
        bootstrap.user_data.should =~ /chef_organization\s+.*\'#{org}\'.*/
      end

      it 'returns a string that contains the chef username' do
        org = bootstrap_def['chef_username']
        bootstrap.user_data.should =~ /chef_username\s+.*\'#{org}\'.*/
      end

      it 'returns a string that contains the environment' do
        env = bootstrap_def['environment']
        bootstrap.user_data.should =~ /environment\s+.*\'#{env}\'.*/
      end

      it 'returns a string that contains the region' do
        region = bootstrap_def['region']
        bootstrap.user_data.should =~ /#{region}/
      end

      it 'returns a string that contains the name' do
        name = bootstrap_def['name']
        bootstrap.user_data.should =~ /#{name}/
      end

      it 'returns a string that contains the elastic_ip' do
        elastic_ip = bootstrap_def['elastic_ip']
        bootstrap.user_data.should =~ /#{elastic_ip}/
      end

      it 'returns a string that contains the run_list as json' do
        run_list = { :run_list => bootstrap_def['run_list'].flatten }.to_json
        bootstrap.user_data.should =~ /#{Regexp.escape(run_list)}/
      end

      it 'returns a string that contains each gem to install' do
        bootstrap_def['gems'].each do |g|
          if g.size > 1
            gem_regexp = /gem\s+install\s+#{g[0]}.+#{g[1]}/
          else
            gem_regexp = /gem\s+install\s+#{g[0]}/
          end
          bootstrap.user_data.should =~ gem_regexp
        end
      end

    end

  end

end
