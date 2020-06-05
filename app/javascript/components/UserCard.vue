<template>
  <div
    :class="[
      classmod,
      'rounded rounded-t-lg overflow-hidden shadow max-w-md bg-white',
    ]"
  >
    <img
      src="https://images.pexels.com/photos/1099339/pexels-photo-1099339.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"
      class="w-full"
    />
    <div class="flex justify-center -mt-8">
      <img
        src="https://t4.ftcdn.net/jpg/00/64/67/63/240_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
        class="rounded-full border-solid border-white border-2 -mt-3 w-20"
      />
    </div>
    <div class="text-center px-3 pb-2 pt-2">
      <h3 class="text-black text-sm font-semibold font-sans">
        {{ currentUser.email }}
      </h3>
    </div>
    <div class="p-3">
      <div class="border-b border-t p-3 mt-4">
        <div
          class="flex flex-col items-center sm:flex-row justify-between pb-3 text-grey-dark"
        >
          <h2 class="font-normal">
            Dinero en Bitsplit
          </h2>
          <div class="flex mr-3 font-thin">
            <div class="text-center mr-3 pr-3">
              <h2>{{ userBalanceBitsplitBTC }}</h2>
              <span>BTC</span>
            </div>
            <div class="text-center mr-3 pr-3">
              <h2>${{ userBalanceBitsplitBTCCLP }}</h2>
              <span>CLP aprox</span>
            </div>
          </div>
        </div>
      </div>
      <div class="p-3">
        <div
          class="flex flex-col items-center sm:flex-row justify-between pb-3 text-grey-dark"
        >
          <h2 class="font-normal">
            Dinero en buda
          </h2>
          <div class="flex mr-3 font-thin">
            <div class="text-center mr-3 pr-3">
              <h2>{{ userBalanceBudaBTC }}</h2>
              <span>BTC</span>
            </div>
            <div class="text-center mr-3 border-r pr-3">
              <h2>${{ userBalanceBudaBTCCLP }}</h2>
              <span>CLP aprox</span>
            </div>
            <div class="text-center">
              <h2>${{ userBalanceBudaCLP }}</h2>
              <span>CLP</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex';

export default {
  name: 'UserCard',
  props: {
    classmod: {
      type: String,
      default: '',
    },
  },
  computed: {
    ...mapState('user', [
      'currentUser',
      'userBalanceBudaCLP',
      'userBalanceBudaBTC',
      'userBalanceBudaBTCCLP',
      'userBalanceBitsplitBTC',
      'userBalanceBitsplitBTCCLP',
    ]),
  },
};
</script>
