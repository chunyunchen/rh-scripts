#! /bin/sh

server=$1
 if [ -$server == "-" ];then
   echo "./ldap.sh <server>"
   exit 0
 fi
ssh -i  ~/libra-new.pem root@$server <<EOF
  yum install openldap* -y
  cat >user-schema.ldif <<!
dn: dc=my-domain,dc=com
dc: my-domain
objectClass: top
objectClass: domain

dn: ou=People,dc=my-domain,dc=com
ou: People
objectClass: organizationalUnit
structuralObjectClass: organizationalUnit
entryUUID: df6192a0-68ed-1030-9e52-15d309d53dfb
creatorsName: cn=Manager,dc=my-domain,dc=com
createTimestamp: 20110901135602Z
entryCSN: 20110901135602.136268Z#000000#000#000000
modifiersName: cn=Manager,dc=my-domain,dc=com
modifyTimestamp: 20110901135602Z

dn: ou=Groups,dc=my-domain,dc=com
ou: Groups
objectClass: organizationalUnit
structuralObjectClass: organizationalUnit
entryUUID: df6192a0-68ed-1030-9e52-15d309d53dfb
creatorsName: cn=Manager,dc=my-domain,dc=com
createTimestamp: 20110901135602Z
entryCSN: 20110901135602.136268Z#000000#000#000000
modifiersName: cn=Manager,dc=my-domain,dc=com
modifyTimestamp: 20110901135602Z

dn: uid=admin,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: Firstname Lastname
uid: admin
uidNumber: 3000
gidNumber: 3000
homeDirectory: /home/adminhomedir
loginShell: /bin/bash
userPassword: password
structuralObjectClass: account
entryUUID: c0c1a9ac-6c08-1030-98d4-2d6b3a6d97ae
creatorsName: cn=Manager,dc=my-domain,dc=com
createTimestamp: 20110905124600Z
entryCSN: 20110905124600.656658Z#000000#000#000000
modifiersName: cn=Manager,dc=my-domain,dc=com
modifyTimestamp: 20110905124600Z
!
slapadd -l user-schema.ldif -c >>/dev/null 
echo "olcRootPW: redhat" >>/etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}bdb.ldif
chown -R ldap.ldap /var/lib/ldap;lokkit --port=389:tcp ;/etc/init.d/slapd start;chkconfig slapd on

cat >member.ldif <<!
dn: cn=Test1 User1,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test1 User1
sn: User1
uid: tuser1

dn: cn=Test2 User2,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test2 User2
sn: User2
uid: tuser2

dn: cn=Test3 User3,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test3 User3
sn: User3
uid: tuser3

dn: cn=Test4 User4,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test4 User4
sn: User4
uid: tuser4

dn: cn=Test5 User5,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test5 User5
sn: User5
uid: tuser5

dn: cn=Test6 User6,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test6 User6
sn: User6
uid: tuser6

dn: cn=Test7 User7,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test7 User7
sn: User7
uid: tuser7

dn: cn=Test8 User8,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test8 User8
sn: User8
uid: tuser8

dn: cn=Test9 User9,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test9 User9
sn: User9
uid: tuser9

dn: cn=Test10 User10,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test10 User10
sn: User10
uid: tuser10

dn: cn=Test11 User11,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test11 User11
sn: User11
uid: tuser11

dn: cn=Test12 User12,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test12 User12
sn: User12
uid: tuser12

dn: cn=Test13 User13,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test13 User13
sn: User13
uid: tuser13

dn: cn=Test14 User14,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test14 User14
sn: User14
uid: tuser14

dn: cn=Test15 User15,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test15 User15
sn: User15
uid: tuser15

dn: cn=Test16 User16,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test16 User16
sn: User16
uid: tuser16

dn: cn=Test17 User17,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test17 User17
sn: User17
uid: tuser17

dn: cn=Test18 User18,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test18 User18
sn: User18
uid: tuser18

dn: cn=Test19 User19,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test19 User19
sn: User19
uid: tuser19

dn: cn=Test20 User20,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test20 User20
sn: User20
uid: tuser20

dn: cn=Test21 User21,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test21 User21
sn: User21
uid: tuser21

dn: cn=Test22 User22,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test22 User22
sn: User22
uid: tuser22

dn: cn=Test23 User23,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test23 User23
sn: User23
uid: tuser23

dn: cn=Test24 User24,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test24 User24
sn: User24
uid: tuser24

dn: cn=Test25 User25,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test25 User25
sn: User25
uid: tuser25

dn: cn=Test26 User26,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test26 User26
sn: User26
uid: tuser26

dn: cn=Test27 User27,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test27 User27
sn: User27
uid: tuser27

dn: cn=Test28 User28,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test28 User28
sn: User28
uid: tuser28

dn: cn=Test29 User29,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test29 User29
sn: User29
uid: tuser29

dn: cn=Test30 User30,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test30 User30
sn: User30
uid: tuser30

dn: cn=Test31 User31,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test31 User31
sn: User31
uid: tuser31

dn: cn=Test32 User32,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test32 User32
sn: User32
uid: tuser32

dn: cn=Test33 User33,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test33 User33
sn: User33
uid: tuser33

dn: cn=Test34 User34,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test34 User34
sn: User34
uid: tuser34

dn: cn=Test35 User35,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test35 User35
sn: User35
uid: tuser35

dn: cn=Test36 User36,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test36 User36
sn: User36
uid: tuser36

dn: cn=Test37 User37,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test37 User37
sn: User37
uid: tuser37

dn: cn=Test38 User38,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test38 User38
sn: User38
uid: tuser38

dn: cn=Test39 User39,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test39 User39
sn: User39
uid: tuser39

dn: cn=Test40 User40,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test40 User40
sn: User40
uid: tuser40

dn: cn=Test41 User41,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test41 User41
sn: User41
uid: tuser41

dn: cn=Test42 User42,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test42 User42
sn: User42
uid: tuser42

dn: cn=Test43 User43,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test43 User43
sn: User43
uid: tuser43

dn: cn=Test44 User44,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test44 User44
sn: User44
uid: tuser44

dn: cn=Test45 User45,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test45 User45
sn: User45
uid: tuser45

dn: cn=Test46 User46,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test46 User46
sn: User46
uid: tuser46

dn: cn=Test47 User47,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test47 User47
sn: User47
uid: tuser47

dn: cn=Test48 User48,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test48 User48
sn: User48
uid: tuser48

dn: cn=Test49 User49,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test49 User49
sn: User49
uid: tuser49

dn: cn=Test50 User50,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test50 User50
sn: User50
uid: tuser50

dn: cn=Test51 User51,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test51 User51
sn: User51
uid: tuser51

dn: cn=Test52 User52,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test52 User52
sn: User52
uid: tuser52

dn: cn=Test53 User53,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test53 User53
sn: User53
uid: tuser53

dn: cn=Test54 User54,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test54 User54
sn: User54
uid: tuser54

dn: cn=Test55 User55,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test55 User55
sn: User55
uid: tuser55

dn: cn=Test56 User56,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test56 User56
sn: User56
uid: tuser56

dn: cn=Test57 User57,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test57 User57
sn: User57
uid: tuser57

dn: cn=Test58 User58,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test58 User58
sn: User58
uid: tuser58

dn: cn=Test59 User59,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test59 User59
sn: User59
uid: tuser59

dn: cn=Test60 User60,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test60 User60
sn: User60
uid: tuser60

dn: cn=Test61 User61,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test61 User61
sn: User61
uid: tuser61

dn: cn=Test62 User62,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test62 User62
sn: User62
uid: tuser62

dn: cn=Test63 User63,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test63 User63
sn: User63
uid: tuser63

dn: cn=Test64 User64,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test64 User64
sn: User64
uid: tuser64

dn: cn=Test65 User65,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test65 User65
sn: User65
uid: tuser65

dn: cn=Test66 User66,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test66 User66
sn: User66
uid: tuser66

dn: cn=Test67 User67,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test67 User67
sn: User67
uid: tuser67

dn: cn=Test68 User68,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test68 User68
sn: User68
uid: tuser68

dn: cn=Test69 User69,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test69 User69
sn: User69
uid: tuser69

dn: cn=Test70 User70,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test70 User70
sn: User70
uid: tuser70

dn: cn=Test71 User71,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test71 User71
sn: User71
uid: tuser71

dn: cn=Test72 User72,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test72 User72
sn: User72
uid: tuser72

dn: cn=Test73 User73,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test73 User73
sn: User73
uid: tuser73

dn: cn=Test74 User74,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test74 User74
sn: User74
uid: tuser74

dn: cn=Test75 User75,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test75 User75
sn: User75
uid: tuser75

dn: cn=Test76 User76,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test76 User76
sn: User76
uid: tuser76

dn: cn=Test77 User77,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test77 User77
sn: User77
uid: tuser77

dn: cn=Test78 User78,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test78 User78
sn: User78
uid: tuser78

dn: cn=Test79 User79,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test79 User79
sn: User79
uid: tuser79

dn: cn=Test80 User80,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test80 User80
sn: User80
uid: tuser80

dn: cn=Test81 User81,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test81 User81
sn: User81
uid: tuser81

dn: cn=Test82 User82,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test82 User82
sn: User82
uid: tuser82

dn: cn=Test83 User83,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test83 User83
sn: User83
uid: tuser83

dn: cn=Test84 User84,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test84 User84
sn: User84
uid: tuser84

dn: cn=Test85 User85,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test85 User85
sn: User85
uid: tuser85

dn: cn=Test86 User86,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test86 User86
sn: User86
uid: tuser86

dn: cn=Test87 User87,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test87 User87
sn: User87
uid: tuser87

dn: cn=Test88 User88,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test88 User88
sn: User88
uid: tuser88

dn: cn=Test89 User89,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test89 User89
sn: User89
uid: tuser89

dn: cn=Test90 User90,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test90 User90
sn: User90
uid: tuser90

dn: cn=Test91 User91,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test91 User91
sn: User91
uid: tuser91

dn: cn=Test92 User92,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test92 User92
sn: User92
uid: tuser92

dn: cn=Test93 User93,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test93 User93
sn: User93
uid: tuser93

dn: cn=Test94 User94,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test94 User94
sn: User94
uid: tuser94

dn: cn=Test95 User95,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test95 User95
sn: User95
uid: tuser95

dn: cn=Test96 User96,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test96 User96
sn: User96
uid: tuser96

dn: cn=Test97 User97,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test97 User97
sn: User97
uid: tuser97

dn: cn=Test98 User98,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test98 User98
sn: User98
uid: tuser98

dn: cn=Test99 User99,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test99 User99
sn: User99
uid: tuser99

dn: cn=Test100 User100,ou=People,dc=my-domain,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Test100 User100
sn: User100
uid: tuser100

dn: cn=first ten,ou=Groups,dc=my-domain,dc=com
objectClass: top
objectClass: groupOfNames
cn: first ten
member: uid=tuser1
member: uid=tuser2
member: uid=tuser3
member: uid=tuser4
member: uid=tuser5
member: uid=tuser6
member: uid=tuser7
member: uid=tuser8
member: uid=tuser9
member: uid=tuser10

dn: cn=first twenty,ou=Groups,dc=my-domain,dc=com
objectClass: top
objectClass: groupOfNames
cn: first twenty
member: uid=tuser1
member: uid=tuser2
member: uid=tuser3
member: uid=tuser4
member: uid=tuser5
member: uid=tuser6
member: uid=tuser7
member: uid=tuser8
member: uid=tuser9
member: uid=tuser10
member: uid=tuser11
member: uid=tuser12
member: uid=tuser13
member: uid=tuser14
member: uid=tuser15
member: uid=tuser16
member: uid=tuser17
member: uid=tuser18
member: uid=tuser19
member: uid=tuser20

dn: cn=first fifty,ou=Groups,dc=my-domain,dc=com
objectClass: top
objectClass: groupOfNames
cn: first fifty
member: uid=tuser1
member: uid=tuser2
member: uid=tuser3
member: uid=tuser4
member: uid=tuser5
member: uid=tuser6
member: uid=tuser7
member: uid=tuser8
member: uid=tuser9
member: uid=tuser10
member: uid=tuser11
member: uid=tuser12
member: uid=tuser13
member: uid=tuser14
member: uid=tuser15
member: uid=tuser16
member: uid=tuser17
member: uid=tuser18
member: uid=tuser19
member: uid=tuser20
member: uid=tuser21
member: uid=tuser22
member: uid=tuser23
member: uid=tuser24
member: uid=tuser25
member: uid=tuser26
member: uid=tuser27
member: uid=tuser28
member: uid=tuser29
member: uid=tuser30
member: uid=tuser31
member: uid=tuser32
member: uid=tuser33
member: uid=tuser34
member: uid=tuser35
member: uid=tuser36
member: uid=tuser37
member: uid=tuser38
member: uid=tuser39
member: uid=tuser40
member: uid=tuser41
member: uid=tuser42
member: uid=tuser43
member: uid=tuser44
member: uid=tuser45
member: uid=tuser46
member: uid=tuser47
member: uid=tuser48
member: uid=tuser49
member: uid=tuser50

dn: cn=odds,ou=Groups,dc=my-domain,dc=com
objectClass: top
objectClass: groupOfNames
cn: odds
member: uid=tuser1
member: uid=tuser3
member: uid=tuser5
member: uid=tuser7
member: uid=tuser9
member: uid=tuser11
member: uid=tuser13
member: uid=tuser15
member: uid=tuser17
member: uid=tuser19
member: uid=tuser21
member: uid=tuser23
member: uid=tuser25
member: uid=tuser27
member: uid=tuser29
member: uid=tuser31
member: uid=tuser33
member: uid=tuser35
member: uid=tuser37
member: uid=tuser39
member: uid=tuser41
member: uid=tuser43
member: uid=tuser45
member: uid=tuser47
member: uid=tuser49
member: uid=tuser51
member: uid=tuser53
member: uid=tuser55
member: uid=tuser57
member: uid=tuser59
member: uid=tuser61
member: uid=tuser63
member: uid=tuser65
member: uid=tuser67
member: uid=tuser69
member: uid=tuser71
member: uid=tuser73
member: uid=tuser75
member: uid=tuser77
member: uid=tuser79
member: uid=tuser81
member: uid=tuser83
member: uid=tuser85
member: uid=tuser87
member: uid=tuser89
member: uid=tuser91
member: uid=tuser93
member: uid=tuser95
member: uid=tuser97
member: uid=tuser99

dn: cn=evens,ou=Groups,dc=my-domain,dc=com
objectClass: top
objectClass: groupOfNames
cn: evens
member: uid=tuser2
member: uid=tuser4
member: uid=tuser6
member: uid=tuser8
member: uid=tuser10
member: uid=tuser12
member: uid=tuser14
member: uid=tuser16
member: uid=tuser18
member: uid=tuser20
member: uid=tuser22
member: uid=tuser24
member: uid=tuser26
member: uid=tuser28
member: uid=tuser30
member: uid=tuser32
member: uid=tuser34
member: uid=tuser36
member: uid=tuser38
member: uid=tuser40
member: uid=tuser42
member: uid=tuser44
member: uid=tuser46
member: uid=tuser48
member: uid=tuser50
member: uid=tuser52
member: uid=tuser54
member: uid=tuser56
member: uid=tuser58
member: uid=tuser60
member: uid=tuser62
member: uid=tuser64
member: uid=tuser66
member: uid=tuser68
member: uid=tuser70
member: uid=tuser72
member: uid=tuser74
member: uid=tuser76
member: uid=tuser78
member: uid=tuser80
member: uid=tuser82
member: uid=tuser84
member: uid=tuser86
member: uid=tuser88
member: uid=tuser90
member: uid=tuser92
member: uid=tuser94
member: uid=tuser96
member: uid=tuser98
member: uid=tuser100

dn: cn=all,ou=Groups,dc=my-domain,dc=com
objectClass: top
objectClass: groupOfNames
cn: all
member: uid=tuser1
member: uid=tuser2
member: uid=tuser3
member: uid=tuser4
member: uid=tuser5
member: uid=tuser6
member: uid=tuser7
member: uid=tuser8
member: uid=tuser9
member: uid=tuser10
member: uid=tuser11
member: uid=tuser12
member: uid=tuser13
member: uid=tuser14
member: uid=tuser15
member: uid=tuser16
member: uid=tuser17
member: uid=tuser18
member: uid=tuser19
member: uid=tuser20
member: uid=tuser21
member: uid=tuser22
member: uid=tuser23
member: uid=tuser24
member: uid=tuser25
member: uid=tuser26
member: uid=tuser27
member: uid=tuser28
member: uid=tuser29
member: uid=tuser30
member: uid=tuser31
member: uid=tuser32
member: uid=tuser33
member: uid=tuser34
member: uid=tuser35
member: uid=tuser36
member: uid=tuser37
member: uid=tuser38
member: uid=tuser39
member: uid=tuser40
member: uid=tuser41
member: uid=tuser42
member: uid=tuser43
member: uid=tuser44
member: uid=tuser45
member: uid=tuser46
member: uid=tuser47
member: uid=tuser48
member: uid=tuser49
member: uid=tuser50
member: uid=tuser51
member: uid=tuser52
member: uid=tuser53
member: uid=tuser54
member: uid=tuser55
member: uid=tuser56
member: uid=tuser57
member: uid=tuser58
member: uid=tuser59
member: uid=tuser60
member: uid=tuser61
member: uid=tuser62
member: uid=tuser63
member: uid=tuser64
member: uid=tuser65
member: uid=tuser66
member: uid=tuser67
member: uid=tuser68
member: uid=tuser69
member: uid=tuser70
member: uid=tuser71
member: uid=tuser72
member: uid=tuser73
member: uid=tuser74
member: uid=tuser75
member: uid=tuser76
member: uid=tuser77
member: uid=tuser78
member: uid=tuser79
member: uid=tuser80
member: uid=tuser81
member: uid=tuser82
member: uid=tuser83
member: uid=tuser84
member: uid=tuser85
member: uid=tuser86
member: uid=tuser87
member: uid=tuser88
member: uid=tuser89
member: uid=tuser90
member: uid=tuser91
member: uid=tuser92
member: uid=tuser93
member: uid=tuser94
member: uid=tuser95
member: uid=tuser96
member: uid=tuser97
member: uid=tuser98
member: uid=tuser99
member: uid=tuser100
!
ldapadd -x -D "cn=Manager,dc=my-domain,dc=com" -w redhat -f member.ldif
EOF
