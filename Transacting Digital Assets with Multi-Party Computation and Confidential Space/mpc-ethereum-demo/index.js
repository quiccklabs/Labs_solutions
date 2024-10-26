import {signTransaction, submitTransaction, uploadFromMemory} from './mpc.js';

const signAndSubmitTransaction = async () => {
  try {
    // Create the unsigned transaction object
    const unsignedTransaction = {
      nonce: 0,
      gasLimit: 21000,
      gasPrice: '0x09184e72a000',
      to: '0x0000000000000000000000000000000000000000',
      value: '0x00',
      data: '0x',
    };

    // Sign the transaction
    const signedTransaction = await signTransaction(unsignedTransaction);

    // Submit the transaction to Ganache
    const transaction = await submitTransaction(signedTransaction);

    // Write the transaction receipt
    uploadFromMemory(transaction);

    return transaction;
  } catch (e) {
    console.log(e);
    uploadFromMemory(e);
  }
};

await signAndSubmitTransaction();
