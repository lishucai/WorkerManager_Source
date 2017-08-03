using System.Drawing;
using ThoughtWorks.QRCode.Codec;

/// <summary>
/// QTCodeImportor 的摘要说明
/// </summary>
public class QTCodeImportor
{

    /// <summary>
    /// 调用此函数后使此两种图片合并，类似相册，有个
    /// 背景图，中间贴自己的目标图片
    /// </summary>
    /// <param name="imgBack">粘贴的源图片</param>
    /// <param name="destImg">粘贴的目标图片</param>
    public static Image CombinImage(Image imgBack, string destImg)
    {
        int bigImgWidth = imgBack.Width;
        int bigImgHeight = imgBack.Height;
        Image img = Image.FromFile(destImg);

        int littleImgWidth = bigImgWidth / 4;
        int littleImgHeight = img.Height * littleImgWidth / img.Width;

        using (Graphics g = Graphics.FromImage(imgBack))
        {
           // g.DrawImage(imgBack, 0, 0);
            Rectangle descRect = new Rectangle((bigImgWidth - littleImgWidth) / 2, (bigImgHeight - littleImgHeight) / 2, littleImgWidth, littleImgHeight);
            Rectangle srcRect = new Rectangle(0, 0, img.Width, img.Height);
            g.DrawImage(img, descRect, srcRect, GraphicsUnit.Pixel);
        }

        return imgBack;
    }
    /// <summary>
    /// Resize图片
    /// </summary>
    /// <param name="bmp">原始Bitmap</param>
    /// <param name="newW">新的宽度</param>
    /// <param name="newH">新的高度</param>
    /// <param name="Mode">保留着，暂时未用</param>
    /// <returns>处理以后的图片</returns>
    private static Image KiResizeImage(Image bmp, int newW, int newH, int Mode)
    {
        try
        {
            Image b = new Bitmap(newW, newH);
            Graphics g = Graphics.FromImage(b);
            // 插值算法的质量
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
            g.DrawImage(bmp, new Rectangle(0, 0, newW, newH), new Rectangle(0, 0, bmp.Width, bmp.Height), GraphicsUnit.Pixel);
            g.Dispose();
            return b;
        }
        catch
        {
            return null;
        }
    }

    public static Image CreateQTCode(string qtcodeData, string[] desc)
    {
        QRCodeEncoder encoder = new QRCodeEncoder();
        encoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;//编码方式(注意：BYTE能支持中文，ALPHA_NUMERIC扫描出来的都是数字)
        encoder.QRCodeScale = 4;//大小(值越大生成的二维码图片像素越高)
        encoder.QRCodeVersion = 0;//版本(注意：设置为0主要是防止编码的字符串太长时发生错误)
        encoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.M;//错误效验、错误更正(有4个等级)
        System.Drawing.Bitmap bp = encoder.Encode(qtcodeData, System.Text.Encoding.GetEncoding("GB2312"));

        int width = bp.Width;
        int height = bp.Height;
        //文字描信息区域大小
        Size[] txtbounds = null;

        if (desc != null && desc.Length > 0)
        {
            txtbounds = new Size[desc.Length];
            for (int i = 0; i < desc.Length; i++)
            {
                Size size = System.Windows.Forms.TextRenderer.MeasureText(desc[i], SystemFonts.SmallCaptionFont);
                txtbounds[i] = size;
                height += size.Height;
            }
        }

        System.Drawing.Bitmap result = new Bitmap(width, height);
        Graphics g = Graphics.FromImage(result);
        g.DrawImage(bp, new Point(0, 0));
        Point pos = new Point(0, bp.Height);
        for (int i = 0; i < desc.Length; i++)
        {
            pos.X = (bp.Width - txtbounds[i].Width) / 2;
            if (string.IsNullOrEmpty(desc[i]))
                continue;
            g.DrawString(desc[i], SystemFonts.DefaultFont, Brushes.Black, pos);
            pos.Y += txtbounds[i].Height;
        }

        return result;
    }

}


