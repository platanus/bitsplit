import { shallowMount } from '@vue/test-utils'
import InputLabel from '../InputLabel'

describe('InputLabel', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(InputLabel, {
      propsData: {
        fieldName: 'name',
        fieldFor: 'for'
      }
    })
    expect(wrapper).toMatchSnapshot()
  })
})
