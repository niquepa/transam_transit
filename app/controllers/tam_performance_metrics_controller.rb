class TamPerformanceMetricsController < ApplicationController

  before_action :set_tam_policy_and_group
  before_action :set_tam_performance_metric, only: [:show, :edit, :update, :destroy]

  # GET /tam_performance_metrics
  def index
    @tam_performance_metrics = TamPerformanceMetric.all
  end

  # GET /tam_performance_metrics/1
  def show
  end

  # GET /tam_performance_metrics/new
  def new
    @tam_performance_metric = TamPerformanceMetric.new
  end

  # GET /tam_performance_metrics/1/edit
  def edit
  end

  # POST /tam_performance_metrics
  def create
    @tam_performance_metric = TamPerformanceMetric.new(tam_performance_metric_params)

    if @tam_performance_metric.save
      redirect_to @tam_performance_metric, notice: 'Tam performance metric was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tam_performance_metrics/1
  def update
    respond_to do |format|
      if @tam_performance_metric.update!(tam_performance_metric_params)
        format.json { head :no_content } # 204 No Content
      else
        format.json { render json: @tam_performance_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tam_performance_metrics/1
  def destroy
    @tam_performance_metric.destroy
    redirect_to tam_performance_metrics_url, notice: 'Tam performance metric was successfully destroyed.'
  end

  private

    def set_tam_policy_and_group
      @tam_policy = TamPolicy.find_by(object_key: params[:tam_policy_id])
      @tam_group = TamGroup.find_by(object_key: params[:tam_group_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_tam_performance_metric
      @tam_performance_metric = TamPerformanceMetric.find_by(object_key: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tam_performance_metric_params
      params.require(:tam_performance_metric).permit(TamPerformanceMetric.allowable_params)
    end
end
