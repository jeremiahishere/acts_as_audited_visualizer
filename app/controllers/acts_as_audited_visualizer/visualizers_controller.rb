module ActsAsAuditedVisualizer
  class VisualizersController < ApplicationController
    def index
      # canvas goes here
    end

    # get all audits created after the given timestamp
    # if the timestamp is set to "undefined", return all audits in the last day
    #
    # audits are return with the format
    # {
    #   audit_id_1: [
    #     { model: "User", id: "user_id", name: "User's name" }
    #     { model: "auditable type", id: "auditable id", name: "Thing's name" }
    #     { other models are guessed using and stored with the same method }
    #   ]
    #   audit_id_2: [
    #     ...
    #   ]
    # }
    def update_audits
      created_at = nil
      if params[:timestamp] == "undefined"
        created_at = 1.year.ago
      else
        created_at = Time.at(params[:timestamp].to_i/1000).localtime
      end
      audits = Audit.where(["created_at > ?", created_at])
      output = {}
      audits.each do |audit|
        record = []
        # user
        user = User.find_by_id(audit.user_id)
        if user
          record.push({
            :model => "User", 
            :id => audit.user_id, 
            :name => user.name
          })
        end
        # base record
        record.push({
          :model => audit.auditable_type,
          :id => audit.auditable_id,
          :name => audit.auditable_type.constantize.find_by_id(audit.auditable_id).name
        })
        # guess the other records
        audit.audit_changes.each_pair do |key, value|
          if key.match(/_id$/)
            key_model = key.gsub(/_id$/, "").camelize
            if key_model.constantize
              instance = key_model.constantize.find_by_id(value)
              if !instance.nil? && instance.respond_to?(:name)
                record.push({
                  :model => key_model,
                  :id => value,
                  :name => instance.name
                })
              end
            end
          end
        end
        output[audit[:id]] = record
      end

      respond_to do |format|
        format.json { render :json => output.to_json }  
      end
    end
  end
end
