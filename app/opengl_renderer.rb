class OpenGLRenderer
  attr_accessor :context

  def initialze(context)
    super(context)
  end
  def onSurfaceCreated(gl, config)
    gl.glClearColor(0, 0, 0, 1)
    gl.glShadeModel(gl.GL_SMOOTH)
    gl.glClearDepthf(1.0)

    p gl.class
    loadTextures(gl)
  end

  def loadTextures(gl)
    @texture_to_draw = Texture2D.new(gl)
    p = Person.new
    bitmap = p.get_circular_photo_bitmap(@context, "img", 100)
    @texture_to_draw.load_texture_from_bitmap(bitmap)
  end

  def onSurfaceChanged(gl, width, height)
    gl.glViewport(0, 0, width, height)
    gl.glMatrixMode(gl.GL_PROJECTION)
    gl.glLoadIdentity()
    gl.glMatrixMode(gl.GL_MODELVIEW)
    gl.glLoadIdentity()
  end

  def onDrawFrame(gl)
    gl.glClear(gl.GL_COLOR_BUFFER_BIT)
    gl.glLoadIdentity()
    gl.glClearColor(1, 0, 0, 1)
    Texture2D.enableClientState(gl)
    @texture_to_draw.drawInRect(Android::Graphics::Rect.new(100, 100, 200, 200))
    Texture2D.disableClientState(gl)
  end

end
