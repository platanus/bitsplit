// Todo agregar informacion general del usuario
<template>
  <div>
    <div class="txt-card lg:flex">
      <div class="w-1/3 text-center py-8">
        <div class="border-r">
          <div class="text-grey-darker mb-2">
            <span class="text-xl align-top">Bitsplit Wallet</span>
          </div>
          <div class="text-sm uppercase text-grey tracking-wide py-10">
            {{ userBalanceBitsplitBTC }} BTC
          </div>
          <div class="text-sm uppercase text-grey tracking-wide">
            {{ userBalanceBitsplitCLP }} CLP Aprox
          </div>
        </div>
      </div>
      <div class="w-1/3 text-center py-8">
        <div class="border-r">
          <div class="text-grey-darker mb-2">
            <span class="text-xl align-top"> Buda Wallet</span>
          </div>
          <div class="text-sm uppercase text-grey tracking-wide py-10">
            {{ userBalanceBudaBTC }} BTC
          </div>
          <div class="text-sm uppercase text-grey tracking-wide">
            {{ userBalanceBudaCLP }} CLP aprox
          </div>
        </div>
      </div>
      <div class="w-1/3 text-center py-8">
        <div>
          <div class="text-grey-darker mb-2">
            <span class="text-xl align-top"> Splitwise </span>
          </div>
          <div class="text-sm text-grey tracking-wide py-10">
            Me deben: $ 5.000
          </div>
          <div class="text-sm text-grey tracking-wide">
            Debo a amigos: $ 3.000
          </div>
        </div>
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
