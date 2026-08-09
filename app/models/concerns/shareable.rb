module Shareable
  extend ActiveSupport::Concern

  SHAREABLE_MODELS = [ Transaction, View ]

  def self.available_shareables(user)
    available_shareables_list = []

    Shareable::SHAREABLE_MODELS.each do |model|
      available_shareables_list.push [ model.name.humanize, model.all.select { |record| Pundit.policy(user, record).share? }.map { |r| [ r.display_name, r.to_global_id.to_s ] }  ]
    end

    available_shareables_list
  end
end
