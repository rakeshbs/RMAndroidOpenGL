class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
    requestWindowFeature(Android::View::Window::FEATURE_NO_TITLE)
    getWindow().setFlags(Android::View::WindowManager::LayoutParams::FLAG_FULLSCREEN,
                         Android::View::WindowManager::LayoutParams::FLAG_FULLSCREEN)

    @view = Android::Opengl::GLSurfaceView.new(self)

    display = getWindowManager().getDefaultDisplay();
    size = Android::Graphics::Point.new
    display.getSize(size);

    @renderer = OpenGLRenderer.new(self, size.x, size.y)
    @view.setRenderer(@renderer)
    setContentView(@view)

  end
end
