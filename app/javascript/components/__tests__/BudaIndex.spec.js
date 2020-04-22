import { shallowMount } from '@vue/test-utils'
import BudaIndex from '../BudaIndex'

describe('BudaIndex', () => {
  it('matches snapshot', () => {
    const wrapper = shallowMount(BudaIndex)
    expect(wrapper).toMatchSnapshot()
  })
})
