class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
    requestWindowFeature(Android::View::Window::FEATURE_NO_TITLE)
    getWindow().setFlags(Android::View::WindowManager::LayoutParams::FLAG_FULLSCREEN,
                         Android::View::WindowManager::LayoutParams::FLAG_FULLSCREEN)

    @view = Android::Opengl::GLSurfaceView.new(self)

    @renderer = OpenGLRenderer.new
    @renderer.context = self
    @view.setRenderer(@renderer)

    setContentView(@view)

  end
end
