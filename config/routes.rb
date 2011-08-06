Rails.application.routes.draw do
  namespace :acts_as_audited_visualizer do
    match "/" => "visualizers#index"
    match "/update_audits/:timestamp" => "visualizers#update_audits"
  end
end
