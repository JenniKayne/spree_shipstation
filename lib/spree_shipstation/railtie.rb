module SpreeShipstation
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/shipstation.rake'
    end
  end
end
