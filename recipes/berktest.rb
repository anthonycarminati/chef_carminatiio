directory "/opt/carminatiio" do
	mode 755
	owner 'root'
	group 'root'
	recursive true
	action :create
end

cookbook_file "/opt/carminatiio/main.json" do
	source "main.json"
	mode 0644
	action :create_if_missing
end