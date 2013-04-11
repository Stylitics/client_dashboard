require 'spec_helper'

describe 'R Scripts Routing' do
  it 'routes /admin/r_scripts/some-r-script/clear to admin/r_scripts#clear' do
    expect(delete: '/admin/r_scripts/some-r-script/clear').to route_to(
      controller: 'admin/r_scripts',
      action: 'clear',
      id: 'some-r-script'
    )
  end

  it 'routes /admin/r_scripts/some-r-script/activate to admin/r_scripts#activate' do
    expect(put: '/admin/r_scripts/some-r-script/activate').to route_to(
      controller: 'admin/r_scripts',
      action: 'activate',
      id: 'some-r-script'
    )
  end
end
