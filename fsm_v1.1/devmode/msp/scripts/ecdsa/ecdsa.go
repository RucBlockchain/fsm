package main

 import (
 	"crypto/ecdsa"
 	"crypto/elliptic"
 	"crypto/md5"
 	"crypto/rand"
  "crypto/x509"
 	"fmt"
 	"hash"
 	"io"
 	"math/big"
 	"os"
 )

 func main() {

 	publicKeyCurve := elliptic.P256() //see http://golang.org/pkg/crypto/elliptic/#P256

 	privateKey := new(ecdsa.PrivateKey)
 	privateKey, err := ecdsa.GenerateKey(publicKeyCurve, rand.Reader) // this generates a public & private key pair
 	if err != nil {
 		fmt.Println(err)
 		os.Exit(1)
 	}

  private_key_bytes, _ := x509.MarshalECPrivateKey(privateKey)
	public_key_bytes, _ := x509.MarshalPKIXPublicKey(&privateKey.PublicKey)

 	fmt.Println("Private Key:", string(private_key_bytes))

  fmt.Println(":")

 	fmt.Println("Public Key:", string(public_key_bytes))

 	// Sign ecdsa style

 	var h hash.Hash
 	h = md5.New()
 	r := big.NewInt(0)
 	s := big.NewInt(0)

 	io.WriteString(h, "This is a message to be signed and verified by ECDSA!")
 	signhash := h.Sum(nil)

 	r, s, serr := ecdsa.Sign(rand.Reader, privateKey, signhash)
 	if serr != nil {
 		fmt.Println(err)
 		os.Exit(1)
 	}

 	signature := r.Bytes()
 	signature = append(signature, s.Bytes()...)

 	fmt.Printf("Signature : %x\n", signature)

 	// Verify
 	verifystatus := ecdsa.Verify(&privateKey.PublicKey, signhash, r, s)
 	fmt.Println(verifystatus) // should be true*/
 }
