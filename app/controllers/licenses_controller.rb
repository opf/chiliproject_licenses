class LicensesController < ApplicationController
  unloadable

  helper :attachments
  include AttachmentsHelper

  helper :license_versions
  include LicenseVersionsHelper

  before_filter :require_admin, :except => [:index, :show]
  before_filter :get_license_by_identifier, :except => [:index, :new, :create]


  def index
    @licenses = License.all.order(:name)
    @settings = Setting.plugin_openproject_licenses
  end

  def show
    @latest_version = @license.latest_version
    redirect_to license_version_path(id: @license, version_id: @latest_version)
  end

  def edit
  end

  def new
    @license = License.new
    @license.versions.build
  end

  def create
    @license = License.new license_params

    if @license.save
      flash[:notice] = t(:notice_successful_create)
      redirect_to @license
    else
      render action: :new
    end
  end

  def update
    if @license.update_attributes license_params
      flash[:notice] = t(:notice_successful_update)
      redirect_to @license
    else
      render action: :edit
    end
  end

  def destroy
    if @license.versions.count > 1
      @license.destroy

      flash[:notice] = t(:notice_successful_delete)
    else
      flash[:error] = t(:notice_error_delete)
    end

    redirect_to licenses_url
  end

  private

  def get_license_by_identifier
    @license = License.find_by!(identifier: params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def license_params
    license_params = params
      .require(:license)
      .permit(:name, :short_name, :identifier, :description, :url)

    license_params[:logo_data] = params.require(:license).fetch(:attachments, {}).permit!
    license_params[:versions_attributes] = params.require(:license).fetch(:versions_attributes, {}).permit!

    license_params
  end

  def default_breadcrumb
    if action_name == 'index'
      t('label_license_plural')
    else
      ActionController::Base.helpers.link_to(t('label_license_plural'), licenses_path)
    end
  end

  def show_local_breadcrumb
    true
  end
end
