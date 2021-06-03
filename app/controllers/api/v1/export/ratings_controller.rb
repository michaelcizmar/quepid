# frozen_string_literal: true

require 'csv'

module Api
  module V1
    module Export
      class RatingsController < Api::ApiController
        before_action :find_case
        before_action :check_case

        def make_csv_safe str
          if %w[- = + @].include?(str[0])
            " #{str}"
          else
            str
          end
        end

        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity
        # rubocop:disable Metrics/BlockLength
        def show
          file_format = params[:file_format]

          respond_to do |format|
            format.json do
              json_template = file_format.nil? ? 'show.json.jbuilder' : "show.#{file_format.downcase}.json.jbuilder"

              render json_template
            end
            format.csv do
              # We have crazy rendering formatting in the view because we don't want a trailing LF at the end of the
              # CSV, it messes with Quaerite, however the render() call adds a LF, so we need to format our CSV with
              # line feeds on each line except the very last one!

              @csv_array = []
              csv_headers = %w[query docid rating]
              @csv_array << csv_headers

              if 'basic_snapshot' == file_format
                csv_filename = "case_#{@case.id}_snapshot_judgements.csv"
                snapshot = Snapshot.find_by(id: params[:snapshot_id])

                snapshot.snapshot_queries.each do |snapshot_query|
                  if snapshot_query.snapshot_docs.empty?
                    @csv_array << [ make_csv_safe(snapshot_query.query.query_text) ]
                  else
                    snapshot_query.snapshot_docs.each do |snapshot_doc|
                      rating = Rating.find_by(query_id: snapshot_query.query.id, doc_id: snapshot_doc.doc_id)
                      @csv_array << [ make_csv_safe(snapshot_query.query.query_text), snapshot_doc.doc_id,
                                      rating.nil? ? nil : rating.rating ]
                    end
                  end
                end

              else
                csv_filename = "case_#{@case.id}_judgements.csv"

                @case.queries.each do |query|
                  if query.ratings.fully_rated.empty?
                    @csv_array << [ make_csv_safe(query.query_text) ]
                  else
                    query.ratings.fully_rated.each do |rating|
                      @csv_array << [ make_csv_safe(query.query_text), rating.doc_id, rating.rating ]
                    end
                  end
                end
              end

              headers['Content-Disposition'] = "attachment; filename=\"#{csv_filename}\""
              headers['Content-Type'] ||= 'text/csv'
            end
            format.txt do
              headers['Content-Disposition'] = "attachment; filename=\"case_#{@case.id}_judgements.txt\""
              headers['Content-Type'] ||= 'text/plain'
            end
          end
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity
        # rubocop:enable Metrics/BlockLength
      end
    end
  end
end
