using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Web;

/// <summary>
/// Graphics2DUtil 的摘要说明
/// </summary>
public class Graphics2DUtil
{
    public Graphics2DUtil()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    private static GraphicsPath GetRoundedRectPath(Rectangle rect, int radius)
    {
        int diameter = radius;
        Rectangle arcRect = new Rectangle(rect.Location, new Size(diameter, diameter));
        GraphicsPath path = new GraphicsPath();
        // 左上角  
        path.AddArc(arcRect, 180, 90);
        // 右上角  
        arcRect.X = rect.Right - diameter;
        path.AddArc(arcRect, 270, 90);
        // 右下角  
        arcRect.Y = rect.Bottom - diameter;
        path.AddArc(arcRect, 0, 90);
        // 左下角  
        arcRect.X = rect.Left;
        path.AddArc(arcRect, 90, 90);
        path.CloseFigure();
        return path;
    }

    public static Image AppendBorder(int margin, Image img)
    {
        int w = img.Width + margin * 2;
        int h = img.Height + margin * 2;
        Bitmap bm = new Bitmap(w, h);

        using (Graphics g = Graphics.FromImage(bm))
        {
            Rectangle border = new Rectangle(margin/2, margin/2, w - margin, h - margin);
            g.FillRectangle(Brushes.White, 0, 0, w, h);

            GraphicsPath p = GetRoundedRectPath(border,margin);
            g.DrawPath(Pens.Black, p);
            //g.DrawRectangle(Pens.Black, border);
            g.DrawImage(img, margin, margin);

        }
        return bm;
    }

    public static Image CreateBigImage(List<Image> images, int columnns)
    {
        if (images == null && images.Count == 0)
            return null;
        Image img1 = images[0];
        int margin = 15;
        Image bigImg = null;
        int rows = (int)Math.Ceiling((double)images.Count / columnns);
        int width = (img1.Width + margin) * columnns;
        int height = (img1.Height + margin) * rows;
        bigImg = new Bitmap(width, height);

        using (Graphics g = Graphics.FromImage(bigImg))
        {
            g.FillRectangle(Brushes.White, 0, 0, width, height);

            for (int i = 0; i < rows; i++)
            {
                for (int j = 0; j < columnns; j++)
                {
                    int index = i * columnns + j;
                    if (index < images.Count)
                    {
                        Image img = images[index];
                        int offsetX = j * (img1.Width + margin) + margin;
                        int offsetY = i * (img1.Height + margin) + margin;
                        Point pos = new Point(offsetX, offsetY);
                        g.DrawImage(img, pos);
                    }
                }
            }
        }

        return bigImg;
    }
}