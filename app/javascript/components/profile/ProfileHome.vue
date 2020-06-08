// Todo agregar informacion general del usuario
<template>
  <div>
    <div class="txt-card lg:flex">
      <div class="w-1/2 text-center py-8">
        <div class="border-r">
          <div class="text-grey-darker mb-2">
            <span class="text-xl align-top text-indigo-600"
              >Bitsplit Wallet</span
            >
          </div>
          <p class="text-grey-dark mb-4 mt-4 py-10">
            <span class="font-bold text-lg"> {{ userBalanceBitsplitBTC }}</span>
            BTC
          </p>
          <p class="text-grey-dark mb-4 mt-4">
            <span class="font-bold text-lg">
              {{ userBalanceBitsplitBTCCLP }}</span
            >
            CLP aprox
          </p>
        </div>
      </div>
      <div class="w-1/2 text-center py-8">
        <div class="text-grey-darker mb-2">
          <span class="text-xl align-top text-blue-800"> Buda Wallet</span>
        </div>
        <p class="text-grey-dark mb-4 mt-4 py-10">
          <span class="font-bold text-lg"> {{ userBalanceBudaBTC }}</span> BTC
        </p>
        <p class="text-grey-dark mb-4 mt-4">
          <span class="font-bold text-lg"> {{ userBalanceBudaBTCCLP }}</span>
          CLP aprox
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex';

export default {
  name: 'ProfileHome',
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
