# Use jar-dependencies, included with JRuby, to load JFreeChart
require 'jar-dependencies'
require_jar 'org.jfree', 'jfreechart', '1.5.5'

bubble_dataset = org.jfree.data.xy.DefaultXYZDataset.new

# Add values to the dataset
x_values = [30, 40, 50, 60, 70, 80]
y_values = [10, 20, 30, 40, 50, 60]
z_values = [4, 5, 10, 8, 9, 6]
data = [x_values, y_values, z_values]
bubble_dataset.add_series 'Series 1', data

# Create a bubble chart with default settings
java_import org.jfree.chart.ChartFactory
bubble_chart = ChartFactory.create_bubble_chart 'Sample Bubble Chart', 'X', 'Y', bubble_dataset
bubble_chart.set_background_paint java.awt.Color.white
bubble_chart.get_plot.set_background_paint java.awt.Color.blue
bubble_chart.get_plot.set_domain_gridline_paint java.awt.Color.red
bubble_chart.get_plot.set_range_gridline_paint java.awt.Color.yellow

# Create a buffered image in memory at 500x500
bubble_image = bubble_chart.create_buffered_image 500, 500

# Write the image as a PNG to a file
bubble_file = File.open('bubblechart.png', "w")
javax.imageio.ImageIO.write(bubble_image, "PNG", bubble_file.to_outputstream)