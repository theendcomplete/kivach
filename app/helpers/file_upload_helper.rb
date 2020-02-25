module FileUploadHelper
  def self.prepare(source, max_size_mb: 10, allowed_mime: ['image/png', 'image/jpeg'])
    raise Error::BadRequest, code: 'INVALID_FILE' unless source.is_a? ActionDispatch::Http::UploadedFile

    file_path = source.path
    raise Error::InternalServerError, code: 'FILE_NOT_UPLOADED' if file_path.blank?

    file_size = File.size(file_path)
    raise Error::BadRequest, code: 'FILE_SIZE_TOO_BIG' if file_size > max_size_mb * 1_024 * 1_024

    file_type = IO.popen(['file', '--brief', '--mime-type', file_path], &:read).chomp
    raise Error::BadRequest, code: 'FILE_TYPE_NOT_SUPPORTED' unless allowed_mime.include? file_type

    source
  end
end
