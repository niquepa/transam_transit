class NtdReportsController < FormAwareController

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Forms", :forms_path

  # Include the fiscal year mixin
  include FiscalYear

  before_action :get_form
  before_action :get_report,  :except =>  [:create, :download_file]

  def create

    @report = NtdReport.new
    @report.ntd_form = @form
    @report.creator = current_user
    @report.state = @form.state

    if @report.save
      reporting_service = NtdReportingService.new(report: @report)

      @report.ntd_revenue_vehicle_fleets = reporting_service.revenue_vehicle_fleets(Organization.where(id: @form.organization_id))
      @report.ntd_service_vehicle_fleets = reporting_service.service_vehicle_fleets(Organization.where(id: @form.organization_id))
      @report.ntd_facilities = reporting_service.facilities(Organization.where(id: @form.organization_id))


      redirect_to form_ntd_form_ntd_report_url @form_type, @form, @report
    else
      render :new
    end
  end

  def destroy

    @report.destroy
    notify_user(:notice, "Form was successfully removed.")
    respond_to do |format|
      format.html { redirect_to form_ntd_form_path(@form_type, @form) }
      format.json { head :no_content }
    end
  end

  def comments
    respond_to do |format|
      format.js
    end
  end

  def process_log
    respond_to do |format|
      format.js
    end
  end

  def generate

    add_breadcrumb @form_type.name, form_path(@form_type)
    add_breadcrumb @form, form_ntd_form_path(@form_type, @form)
    add_breadcrumb 'Generate', generate_form_ntd_form_ntd_report_path(@form_type, @form, @report)

    # Find out which builder is used to construct the template and create an instance
    builder = DirEntInvTemplateBuilder.new(:ntd_report => @report, :organization_list => [@report.ntd_form.organization_id])

    # Generate the spreadsheet. This returns a StringIO that has been rewound
    stream = builder.build

    # Save the template to a temporary file and render a success/download view
    file = Tempfile.new ['template', '.tmp'], "#{Rails.root}/tmp"
    ObjectSpace.undefine_finalizer(file)
    #You can uncomment this line when debugging locally to prevent Tempfile from disappearing before download.
    @filepath = file.path
    @filename = "#{@report.ntd_form.organization.short_name}_DirEntInv_#{Date.today}.xlsx"
    begin
      file << stream.string
    rescue => ex
      Rails.logger.warn ex
    ensure
      file.close
    end
    # Ensure you're cleaning up appropriately...something wonky happened with
    # Tempfiles not disappearing during testing
    respond_to do |format|
      format.js
      format.html
    end
  end

  def download_file
    # Send it to the user
    filename = params[:filename]
    filepath = params[:filepath]
    data = File.read(filepath)
    send_data data, :filename => filename, :type => "application/vnd.ms-excel"
  end

  protected


  private

  def get_form
    # See if it is our project
    @form = NtdForm.find_by(:object_key => params[:ntd_form_id]) unless params[:ntd_form_id].nil?
    # if not found or the object does not belong to the users
    # send them back to index.html.erb
    if @form.nil?
      notify_user(:alert, 'Record not found!')
      redirect_to(form_ntd_forms_url(@form_type))
      return
    end
  end

  def get_report
    # See if it is our project
    @report = NtdReport.find_by(:object_key => params[:id]) unless params[:id].nil?
    # if not found or the object does not belong to the users
    # send them back to index.html.erb
    if @report.nil?
      notify_user(:alert, 'Record not found!')
      redirect_to(form_ntd_form_url(@form_type, @form))
      return
    end
  end

end
