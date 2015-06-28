class Point < Android::Graphics::Point
end
class OpenGLRenderer

  def initialize(context, width, height)
    @context = context
    @width = width
    @height = height
  end

  def onSurfaceCreated(gl, config)
    gl.glClearColor(0, 0, 0, 1)
    gl.glShadeModel(gl.GL_SMOOTH)
    gl.glClearDepthf(1.0)
    loadTextures(gl)
  end

  def loadTextures(gl)
    @texture_to_draw = Texture2D.new
    bitmap = BitmapReader.get_circular_photo_bitmap(@context, "img", 200)
    @texture_to_draw.load_texture_from_bitmap(gl, bitmap)
  end

  def onSurfaceChanged(gl, width, height)
    gl.glViewport(0, 0, width, height)
    gl.glMatrixMode(gl.GL_PROJECTION)
    gl.glLoadIdentity()
    Android::Opengl::GLU.gluOrtho2D(gl, 0, @width, 0, @height)
    gl.glMatrixMode(gl.GL_MODELVIEW)
    gl.glLoadIdentity()
  end

  def onDrawFrame(gl)
    #begin
    gl.glClear(gl.GL_COLOR_BUFFER_BIT)
    gl.glLoadIdentity()
    gl.glClearColor(0, 0, 0, 1)
    Texture2D.enableStates(gl)
    gl.glEnable(gl.GL_BLEND)
    # Premultiplied alpha
    gl.glBlendFunc(gl.GL_ONE, gl.GL_ONE_MINUS_SRC_ALPHA)
    @texture_to_draw.draw(gl, Point.new(100,100), Point.new(1,1))
    Texture2D.disableStates(gl)

    gl.glDisable(gl.GL_BLEND)
    #rescue Exception => e
    #p e.message
    #end
  end

end
