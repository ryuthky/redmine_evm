class BaselinesController < ApplicationController
  unloadable


  model_object Baseline

  before_filter :find_model_object, :except => [:index, :new, :create]
  before_filter :find_project_from_association, :except => [:index, :new, :create]
  before_filter :find_project_by_project_id, :only => [:index, :new, :create]

  def index
  	@baselines = @project.baselines.all
  end

  def show
    @baseline = Baseline.find(params[:id])
  end

  def new
    @baseline = Baseline.new
  end

  def create
    @baseline = Baseline.new(params[:baseline])
    @baseline.project = @project
    @baseline.state = "open"

    if @baseline.save
      @baseline_versions = @project.versions
      @baseline_versions.each do |version|
        BaselineVersions.create(version)
      end
      redirect_to settings_project_path(@project, :tab => 'baselines')
    end

  end 

  def edit
  end

  def update
    if request.put? && params[:baseline]
      attributes = params[:baseline].dup
      @baseline.safe_attributes = attributes
      if @baseline.save
        flash[:notice] = l(:notice_successful_update)
        redirect_to settings_project_path(@project, :tab => 'baselines')
      else
        render :action => 'edit' 
      end
    end
  end

  def destroy
     
  end

end
