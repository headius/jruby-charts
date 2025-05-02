def validate_environment
  unless RUBY_ENGINE == 'jruby'
    puts 'This example requires JRuby.'
    exit 1
  end
  unless File.exist?('Jars.lock')
    puts 'Jars.lock is missing, please run `jruby -S lock_jars`.'
    exit 1
  end
end

validate_environment

require 'jar-dependencies'
require_jar 'org.jfree', 'jfreechart', '1.5.5'
require_jar 'org.jfree', 'org.jfree.chart3d', '2.1.0'

java_import java.awt.Color
java_import java.awt.Rectangle
java_import java.awt.image.BufferedImage
java_import javax.imageio.ImageIO
java_import org.jfree.chart3d.Chart3DFactory
java_import org.jfree.chart3d.data.DefaultKeyedValues
java_import org.jfree.chart3d.data.category.StandardCategoryDataset3D
java_import org.jfree.chart3d.interaction.StandardKeyedValues3DItemSelection
java_import org.jfree.chart3d.label.StandardCategoryItemLabelGenerator
java_import org.jfree.chart3d.legend.LegendAnchor
java_import org.jfree.chart3d.marker.CategoryMarker

require 'json'

dataset = StandardCategoryDataset3D.new
data_filespec = File.absolute_path(File.join(File.dirname(__FILE__), '../data/app_monitoring_revenue.json'))
data = JSON.load(File.read(data_filespec))
data.each do |name, subset|
  values = DefaultKeyedValues.new
  subset.each { values.put(_1, _2) }
  dataset.add_series_as_row name, values
end

chart = Chart3DFactory.create_bar_chart(
  "Quarterly Revenues",
  "Application & Performance Monitoring Companies",
  dataset, nil, "Quarter",
  "$million Revenues")
chart.chart_box_color = Color.new(255, 255, 255, 127)
chart.legend_anchor = LegendAnchor::BOTTOM_RIGHT

plot = chart.plot
plot.gridline_paint_for_values = Color::BLACK

renderer = plot.renderer
item_label_generator = StandardCategoryItemLabelGenerator.new(StandardCategoryItemLabelGenerator::VALUE_TEMPLATE)
item_selection = StandardKeyedValues3DItemSelection.new
item_label_generator.item_selection = item_selection
renderer.item_label_generator = item_label_generator

width, height = 600, 500
category_chart_image = BufferedImage.new(width, height, BufferedImage::TYPE_INT_RGB)
category_chart_graphics = category_chart_image.create_graphics
chart.draw(category_chart_graphics, Rectangle.new(width, height))

category_chart_file = File.open("category_chart.png", "w")
ImageIO.write(category_chart_image, "PNG", category_chart_file.to_outputstream)

# clean up resources
category_chart_graphics.dispose
category_chart_file.close

require_jar 'org.jfree', 'org.jfree.svg', '5.0.6'
java_import org.jfree.svg.SVGGraphics2D

svg_graphics = SVGGraphics2D.new(width, height)
svg_graphics.defs_key_prefix = "jruby_charts"
chart.element_hinting = true
chart.draw(svg_graphics, Rectangle.new(width, height))
svg = svg_graphics.get_svg_element chart.id
File.write("category_chart.svg", svg)

require_jar 'org.jfree', 'org.jfree.pdf', '2.0.1'
java_import org.jfree.pdf.PDFDocument

pdf_doc = PDFDocument.new
pdf_doc.title = "Application & Performance Monitoring Companies Revenue"
pdf_doc.author = "Charles Oliver Nutter";
page = pdf_doc.create_page(Rectangle.new(612, 468))
pdf_graphics = page.graphics2D
chart.draw(pdf_graphics, Rectangle.new(0, 0, 612, 468))
File.write("category_chart.pdf", pdf_doc.pdf_bytes)
