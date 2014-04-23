# Set will_paginate to use the Bootstrap render
# Also set the default window sizes
WillPaginate::ActionView::LinkRenderer = BootstrapPagination::Rails
WillPaginate::ViewHelpers.pagination_options[:inner_window] = 1
WillPaginate::ViewHelpers.pagination_options[:outer_window] = 1