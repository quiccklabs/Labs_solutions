cd public

rm customer.js

cat > customer.js <<'EOF_END'
let user;

firebase.auth().onAuthStateChanged(function(newUser) {
  user = newUser;
  if (user) {
    const db = firebase.firestore();
    db.collection("customers").doc(user.email).onSnapshot(function(doc) {
      const cust = doc.data();
      if (cust) {
        document.getElementById('customerName').setAttribute('value', cust.name);
        document.getElementById('customerPhone').setAttribute('value', cust.phone);
      }
      document.getElementById('customerEmail').innerText = user.email;
    });
  }
});

document.getElementById('saveProfile').addEventListener('click', function(ev) {
  const db = firebase.firestore();
  var docRef = db.collection('customers').doc(user.email);
  docRef.set({
    name: document.getElementById('customerName').value,
    email: user.email,
    phone: document.getElementById('customerPhone').value,
  })
})
EOF_END


rm styles.css

cat > styles.css <<EOF_END
body { background: #ECEFF1; color: rgba(0,0,0,0.87); font-family: Roboto, Helvetica, Arial, sans-serif; margin: 0; padding: 0; }
#message { background: white; max-width: 360px; margin: 100px auto 16px; padding: 32px 24px 16px; border-radius: 3px; }
#message h3 { color: #888; font-weight: normal; font-size: 16px; margin: 16px 0 12px; }
#message h2 { color: #ffa100; font-weight: bold; font-size: 16px; margin: 0 0 8px; }
#message h1 { font-size: 22px; font-weight: 300; color: rgba(0,0,0,0.6); margin: 0 0 16px;}
#message p { line-height: 140%; margin: 16px 0 24px; font-size: 14px; }
#message a { display: block; text-align: center; background: #039be5; text-transform: uppercase; text-decoration: none; color: white; padding: 16px; border-radius: 4px; }
#message, #message a { box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24); }
#load { color: rgba(0,0,0,0.4); text-align: center; font-size: 13px; }
@media (max-width: 600px) {
  body, #message { margin-top: 0; background: white; box-shadow: none; }
  body { border-top: 16px solid #ffa100; }
}
EOF_END

firebase deploy