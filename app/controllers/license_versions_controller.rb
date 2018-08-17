class LicenseVersionsController < ApplicationController
  layout "no_menu"

  unloadable

  helper :attachments
  include AttachmentsHelper

  before_action :require_admin, :except => :show
  before_action :get_license_by_identifier
  before_action :get_version_by_identifier, :only => [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def new
    @license_version = @license.versions.new
  end

  def create
    @license_version = @license.versions.new license_version_params
    if @license_version.save
      flash[:notice] = t(:notice_successful_create)
      redirect_to license_version_path(id: @license, version_id: @license_version)
    else
      render action: :new
    end
  end

  def update
    if @license_version.update license_version_params
      flash[:notice] = t(:notice_successful_update)
      redirect_to license_version_path(id: @license, version_id: @license_version)
    else
      render action: :edit
    end
  end

  def destroy
    @license_version.destroy
    flash[:notice] = t(:notice_successful_delete)
    redirect_to @license
  end

  private

  def license_version_params
    params
      .require(:license_version)
      .permit(:identifier, :date, :authors, :url, :text)
  end

  def get_license_by_identifier
    @license = License.find_by!(identifier: params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_version_by_identifier
    @license_version = @license.versions.find_by!(identifier: params[:version_id]) if @license
  rescue ActiveRecord::RecordNotFound
    render_404
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
