class BitmapReader

  def self.get_photo_bitmap(context,file_name)
    id = context.resources.getIdentifier(file_name, 'drawable', context.packageName)
    img =  Android::Graphics::BitmapFactory.decodeResource(context.resources, id)
    return img
  end

  def self.get_circular_photo_bitmap(context,file_name,radius)
    create_circular_bitmap(get_photo_bitmap(context,file_name), radius)
  end

  def self.create_circular_bitmap(bitmap, radius)
    if (bitmap.width != radius || bitmap.height != radius)
      scaled_bitmap = Android::Graphics::Bitmap.createScaledBitmap(bitmap, radius, radius, false)
    else
      scaled_bitmap = bitmap
    end
    output = Android::Graphics::Bitmap.createBitmap(scaled_bitmap.width, scaled_bitmap.height,
                                                   Android::Graphics::Bitmap::Config::ARGB_8888)
    canvas = Android::Graphics::Canvas.new(output)
    paint = Android::Graphics::Paint.new()
    rect = Android::Graphics::Rect.new(0, 0, scaled_bitmap.width, scaled_bitmap.height)

    paint.setAntiAlias(true);
    paint.setFilterBitmap(true);
    paint.setDither(true);
    canvas.drawARGB(0, 0, 0, 0);
    paint.setColor(Android::Graphics::Color.parseColor("#BAB399"));
    canvas.drawCircle(scaled_bitmap.width / 2+0.7, scaled_bitmap.height / 2+0.7,
            scaled_bitmap.width / 2+0.1, paint);
    paint.setXfermode(Android::Graphics::PorterDuffXfermode.new(Android::Graphics::PorterDuff::Mode::SRC_IN))
    canvas.drawBitmap(scaled_bitmap, rect, rect, paint);
    return output
  end

end
