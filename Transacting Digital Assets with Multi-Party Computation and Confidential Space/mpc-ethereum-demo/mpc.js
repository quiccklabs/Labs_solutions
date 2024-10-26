import {ethers} from 'ethers';
import {decryptSymmetric} from './kms-decrypt.js';
import {Storage} from '@google-cloud/storage';
import {credentialConfig} from './credential-config.js';

const providers = ethers.providers;
const Wallet = ethers.Wallet;

// The ID of the GCS bucket holding the encrypted keys
const bucketName = process.env.KEY_BUCKET;

// Name of the encrypted key files.
const encryptedKeyFile1 = 'alice-encrypted-key-share';
const encryptedKeyFile2 = 'bob-encrypted-key-share';

// Create a new storage client with the credentials
const storageWithCreds = new Storage({
  credentials: credentialConfig,
});

// Create a new storage client without the credentials
const storage = new Storage();

const downloadIntoMemory = async (keyFile) => {
  // Downloads the file into a buffer in memory.
  const contents = await storageWithCreds.bucket(bucketName).file(keyFile).download();

  return contents;
};

const provider = new providers.JsonRpcProvider(`http://${process.env.NODE_URL}:80`);

export const signTransaction = async (unsignedTransaction) => {
  /* Check if Alice and Bob have both approved the transaction
  For this example, we're checking if their encrypted keys are available. */
  const encryptedKey1 = await downloadIntoMemory(encryptedKeyFile1).catch(console.error);
  const encryptedKey2 = await downloadIntoMemory(encryptedKeyFile2).catch(console.error);

  // For each key share, make a call to KMS to decrypt the key
  const privateKeyshare1 = await decryptSymmetric(encryptedKey1[0]);
  const privateKeyshare2 = await decryptSymmetric(encryptedKey2[0]);

  /* Perform the MPC calculations
  In this example, we're combining the private key shares
  Alternatively, you could import your mpc calculations here */
  const wallet = new Wallet(privateKeyshare1 + privateKeyshare2);

  // Sign the transaction
  const signedTransaction = await wallet.signTransaction(unsignedTransaction);

  return signedTransaction;
};

export const submitTransaction = async (signedTransaction) => {
  // This can now be sent to Ganache
  const hash = await provider.sendTransaction(signedTransaction);
  return hash;
};

export const uploadFromMemory = async (contents) => {
  // Upload the results to the bucket without service account impersonation
  await storage.bucket(process.env.RESULTS_BUCKET)
      .file('transaction_receipt_' + Date.now())
      .save(JSON.stringify(contents));
};
