class BaselineVersion < ActiveRecord::Base
  include Schedulable
  unloadable

  belongs_to :baseline 
  has_many :baseline_issues, dependent: :destroy
  belongs_to :version, :foreign_key => 'original_version_id'

  def start_date # start date for chart?
    @start_date ||= baseline_issues.minimum('start_date') || created_on.to_date #created_on of the normal original version. rename it in te database
  end

  def end_date # end date for chart?
    @end_date = effective_date || baseline.due_date
  end
end

