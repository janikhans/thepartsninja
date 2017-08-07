require 'test_helper'

class DiscoveryFormTest < UnitTest
  should validate_presence_of(:v1).with_message('Base Vehicle must be selected')
  should validate_presence_of(:v2).with_message('Compatible Vehicle(s) must be selected')
  should validate_presence_of(:p1_category)
  should validate_presence_of(:p1_fitment_note)
  should validate_presence_of(:p2_category)
  should validate_presence_of(:p2_fitment_note)
  should validate_presence_of(:user)


  setup do
    @discovery = DiscoveryForm.new(
      v1: vehicles(:yz250),
      v2: [
        { vehicle: vehicles(:yz25008).id, backwards: true, modifications: false },
        { vehicle: vehicles(:yz12506).id, backwards: true, modifications: false },
        { vehicle: vehicles(:wr250).id, backwards: true, modifications: false }
      ],
      p1_category: categories(:wheel_assembly),
      p1_fitment_note: fitment_notes(:front),
      p2_category: categories(:wheel_assembly),
      p2_fitment_note: fitment_notes(:front),
      notes: 'Some potential notes about this discovery',
      user: users(:janik)
    )
  end

  test 'should be valid' do
    assert true
  end
end
