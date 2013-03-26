require 'ftools'


class UploadController < ApplicationController

  # Require authorization before invoking any of this controller's actions:
  before_filter :authorize


  # Default action (upload)
  def index
    redirect_to wip_path()
  end


  # Upload files to Google-Drive or other configured Storage server: 
  def file_upload
    redirect_to wip_path()
    # TODO file_upload_wip
  end


  # Delete or rename uploaded files: 
  def manage_files
    redirect_to wip_path()
  end
  # ---------------------------------------------------------------------------


  # WIP:
  # Low-level local file upload
  def file_upload_wip()
    logger.debug "\r\n\r\n!! ------ in upload/file_upload -----"
    logger.debug params[:datafile].original_filename
    logger.debug params
    logger.debug "\r\n!! ===========================\r\n"
    is_successful = true

    if params[:datafile]
      tmp = params[:datafile].tempfile
      file = File.join( "public/uploads", params[:datafile].original_filename )
      File.cp tmp.path, file
# 
      # name =  params[:datafile].original_filename
      # directory = "public/uploads"
      # path = File.join(directory, name)
      # File.open(path, "wb") { |f|
        # f.write( params[:datafile].read )
      # }
    else
      is_successful = false
    end

    redirect_to upload_path()
  end


  # Delete uploaded files: 
  def kill_file
    logger.debug "\r\n\r\n!! ------ in upload/kill_file -----"
    logger.debug params
    logger.debug "\r\n!! ===========================\r\n"

    # TODO kill file for real

    redirect_to upload_path()
  end
end
