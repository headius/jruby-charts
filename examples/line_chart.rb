# Use jar-dependencies, included with JRuby, to load JFreeChart
require 'jar-dependencies'
require_jar 'org.jfree', 'jfreechart', '1.5.5'

line_dataset = org.jfree.data.xy.DefaultXYDataset.new

# Add values to the dataset
x_values = [1, 2, 3, 4, 5, 6]
y_values = [5, 7, 6, 8, 4, 4]
data = [x_values, y_values]
line_dataset.add_series 'Series 1', data

# Create a line chart with default settings
java_import org.jfree.chart.ChartFactory
line_chart = ChartFactory.create_xy_line_chart 'Sample Line Chart', 'X', 'Y', line_dataset
line_chart.set_background_paint java.awt.Color.white
line_chart.get_plot.set_background_paint java.awt.Color.gray
line_chart.get_plot.set_domain_gridline_paint java.awt.Color.pink
line_chart.get_plot.set_range_gridline_paint java.awt.Color.yellow

# Create a buffered image in memory at 500x500
line_image = line_chart.create_buffered_image 500, 500

# Write the image as a PNG to a file
line_file = File.open('linechart.png', "w")
javax.imageio.ImageIO.write(line_image, "PNG", line_file.to_outputstream)