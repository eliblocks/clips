class S3VideoAnalyzer < ActiveStorage::Analyzer::VideoAnalyzer
  def probe
    IO.popen([ ffprobe_path, "-print_format", "json", "-show_streams", "-v", "error", blob ]) do |output|
      JSON.parse(output.read)
    end
  rescue Errno::ENOENT
    logger.info "Skipping video analysis because FFmpeg isn't installed"
    {}
  end
end