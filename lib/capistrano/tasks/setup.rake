# frozen_string_literal: true

namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        upload! 'config/master.key', "#{shared_path}/config/master.key" unless test("[ -f #{shared_path}/config/master.key ]")
      end
    end
  end
end
