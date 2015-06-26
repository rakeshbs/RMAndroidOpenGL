class Texture2D

  def initialize(gl)
    @gl = gl
  end

  def generate_texture_id
    buffer = Java::Nio::IntBuffer.allocate(1)
    @gl.glGenTextures(1, buffer)
    @texture_id = buffer.array()[0]
  end

  def load_texture_from_bitmap(bitmap)
    generate_texture_id
    @gl.glBindTexture(@gl.GL_TEXTURE_2D, @texture_id)

    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_MIN_FILTER, @gl.GL_LINEAR)
    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_MAG_FILTER, @gl.GL_LINEAR)

    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_WRAP_S,
                       @gl.GL_CLAMP_TO_EDGE)
    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_WRAP_T,
                       @gl.GL_CLAMP_TO_EDGE)

    Android::Opengl::GLUtils.texImage2D(@gl.GL_TEXTURE_2D, 0, bitmap, 0)

    @texture_coordinates = [0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]
    @indices = [0, 1, 3, 0, 3, 2]

    byteBuf = Java::Nio::ByteBuffer.allocateDirect(@texture_coordinates.length * 4)
    byteBuf.order(Java::Nio::ByteOrder.nativeOrder)
    @textureBuffer = byteBuf.asFloatBuffer()
    @textureBuffer.put(@texture_coordinates)
    @textureBuffer.position(0)

    byteBuf = Java::Nio::ByteBuffer.allocateDirect(@texture_coordinates.length * 4)
    byteBuf.order(Java::Nio::ByteOrder.nativeOrder)
    @vertexBuffer = byteBuf.asFloatBuffer()
  end

  def self.enableClientState(gl)
    gl.glEnableClientState(gl.GL_VERTEX_ARRAY)
    gl.glEnableClientState(gl.GL_TEXTURE_COORD_ARRAY)
  end

  def self.disableClientState(gl)
    gl.glDisableClientState(gl.GL_VERTEX_ARRAY)
    gl.glDisableClientState(gl.GL_TEXTURE_COORD_ARRAY)
  end

  def drawInRect(rect)
    @gl.glBindTexture(@gl.GL_TEXTURE_2D, @texture_id)
    c_x = rect.centerX
    c_y = rect.centerY
    h_w = rect.width / 2
    h_h = rect.height / 2

    vertex_coordinates = [c_x - h_w, c_y - h_h, c_x - h_w, c_y + h_h, c_x + h_w, c_y - h_h, c_x + h_w, c_y + h_h]
    @vertexBuffer.put(vertex_coordinates)
    @vertexBuffer.position(0)

    @gl.glVertexPointer(2, @gl.GL_FLOAT, 0, @vertexBuffer)
    @gl.glTexCoordPointer(2, @gl.GL_FLOAT, 0, @textureBuffer)
    @gl.glDrawArrays(@gl.GL_TRIANGLES, 0, 6)
  end

end
