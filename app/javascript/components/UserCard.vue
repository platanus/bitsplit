<template>
  <div
    :class="[
      classmod,
      'rounded rounded-t-lg overflow-hidden shadow max-w-xs bg-white'
    ]"
  >
    <img
      src="https://images.pexels.com/photos/1099339/pexels-photo-1099339.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"
      class="w-full"
    >
    <div class="flex justify-center -mt-8">
      <img
        src="https://t4.ftcdn.net/jpg/00/64/67/63/240_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"
        class="rounded-full border-solid border-white border-2 -mt-3 w-20"
      >
    </div>
    <div class="text-center px-3 pb-6 pt-2">
      <h3 class="text-black text-sm bold font-sans">
        {{ email }}
      </h3>
      <p class="mt-2 font-sans font-light text-grey-dark">
        Hola! Estoy usando Bitsplit
      </p>
    </div>
    <div class="flex justify-center pb-3 text-grey-dark">
      <div class="text-center mr-3 border-r pr-3">
        <h2>${{ clp_balance }}</h2>
        <span>CLP</span>
      </div>
      <div class="text-center">
        <h2>{{ btc_balance }}</h2>
        <span>BTC</span>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'UserCard',
  props: {
    email: String,
    clp_balance: Number,
    btc_balance: Number,
    classmod: {
      type: String,
      default: '',
    },
  },
};
</script>
