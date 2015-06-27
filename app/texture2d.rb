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
    @gl.glEnable(@gl.GL_TEXTURE_2D)
    @gl.glBindTexture(@gl.GL_TEXTURE_2D, @texture_id)

    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_MIN_FILTER, @gl.GL_LINEAR)
    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_MAG_FILTER, @gl.GL_LINEAR)

    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_WRAP_S,
                       @gl.GL_CLAMP_TO_EDGE)
    @gl.glTexParameterf(@gl.GL_TEXTURE_2D, @gl.GL_TEXTURE_WRAP_T,
                       @gl.GL_CLAMP_TO_EDGE)

    Android::Opengl::GLUtils.texImage2D(@gl.GL_TEXTURE_2D, 0, bitmap, 0)

    w = bitmap.width
    h = bitmap.height

    @vertex_coordinates =  [0,   0,   0,   h,   w,   0,   w,   h]
    @texture_coordinates = [0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0.0]
    @indices = [0, 2, 1, 2, 1, 3]

    byteBuf = Java::Nio::ByteBuffer.allocateDirect(@vertex_coordinates.length * 4)
    byteBuf.order(Java::Nio::ByteOrder.nativeOrder)
    @vertexBuffer = byteBuf.asFloatBuffer()
    @vertexBuffer.put(@vertex_coordinates)
    @vertexBuffer.position(0)


    byteBuf = Java::Nio::ByteBuffer.allocateDirect(@texture_coordinates.length * 4)
    byteBuf.order(Java::Nio::ByteOrder.nativeOrder)
    @textureBuffer = byteBuf.asFloatBuffer()
    @textureBuffer.put(@texture_coordinates)
    @textureBuffer.position(0)
    @gl.glDisable(@gl.GL_TEXTURE_2D)

    @indexBuffer = Java::Nio::ByteBuffer.allocateDirect(@indices.length)
    @indexBuffer.order(Java::Nio::ByteOrder.nativeOrder)
    @indexBuffer.put(@indices)
    @indexBuffer.position(0)
  end

  def self.enableClientState(gl)
    gl.glEnable(gl.GL_TEXTURE_2D)
    gl.glEnableClientState(gl.GL_VERTEX_ARRAY)
    gl.glEnableClientState(gl.GL_TEXTURE_COORD_ARRAY)
  end

  def self.disableClientState(gl)
    gl.glDisable(gl.GL_TEXTURE_2D)
    gl.glDisableClientState(gl.GL_VERTEX_ARRAY)
    gl.glDisableClientState(gl.GL_TEXTURE_COORD_ARRAY)
  end

  def draw(position,scale)
    @gl.glBindTexture(@gl.GL_TEXTURE_2D, @texture_id)
    @gl.glPushMatrix
    @gl.glTranslatef(position.x, position.y, 0)
    @gl.glScalef(scale.x, scale.y, 0)
    @gl.glVertexPointer(2, @gl.GL_FLOAT, 0, @vertexBuffer)
    @gl.glTexCoordPointer(2, @gl.GL_FLOAT, 0, @textureBuffer)
    @gl.glDrawElements(@gl.GL_TRIANGLES, @indices.length, @gl.GL_UNSIGNED_BYTE, @indexBuffer)
    @gl.glPopMatrix
  end

end
