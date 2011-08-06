module ActsAsAuditedVisualizer
  class VisualizersController < AppicationController
    def index
      # canvas goes here
    end

    def update_audits
      created_at = params[:timestamp]
      audits = Audit.where(:created_at => created_at)
      output = {}
      audits.each do |audit|
        record = []
        # user
        record.push {
          :model => "User", 
          :id => audit.user_id, 
          :name => User.find_by_id(audit.user_id).name
        }
        # base record
        record.push {
          :model => audit.auditable_type
          :id => audit.auditable_id
          :name => audit.audtiable_type.constantize.find_by_id(audit.auditable_id).name
        }
        # guess the other records
        audit.audit_changes.each_pair do |key, value|
          if key.match(/_id$/)
            key_model = key.gsub(/_id$/, "").camelize
            if key_model.constantize
              instance = key_model.constantize.find_by_id(value)
              if instance
                record.push {
                  :model => key_model,
                  :id => value,
                  :name => instance.name
                }
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
