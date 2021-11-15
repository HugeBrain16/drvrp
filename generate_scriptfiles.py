import os

PLAYERDIRS = [
    "account",
    "accs",
    "food",
    "interior",
    "inventory",
    "job",
    "phone",
    os.path.join("phone", "sms"),
    os.path.join("phone", "call"),
    "position",
    "stats",
    "status",
    "vehicle",
    "weapon",
]

SERVERDIRS = [
    "business",
    os.path.join("business", "clothes"),
    os.path.join("business", "electronic"),
    os.path.join("business", "restaurant"),
    os.path.join("business", "tool"),

    "log",

    "modeldata",
    os.path.join("modeldata", "dutyskin"),
    os.path.join("modeldata", "job-feature"),
    os.path.join("modeldata", "job-feature", "mechanic"),
    os.path.join("modeldata", "job-feature", "mechanic", "tune"),

    "number"
]

SERVERFILES = [
    {"path": "channel.ini", "content": "qna=1\nooc=1"},
    {"path": "ticket.txt", "content": ""},
    {"path": os.path.join("modeldata", "skin.txt"), "content": "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n17\n18\n19\n20\n21\n22\n24\n25\n26\n28\n29\n30\n31\n32\n33\n34\n35\n36\n37\n38\n39\n40\n41\n43\n44\n45\n46\n47\n48\n49\n51\n52\n53\n54\n55\n56\n57\n58\n59\n60\n62\n63\n64\n65\n67\n68\n69\n72\n73\n75\n76\n77\n78\n79\n82\n83\n84\n85\n86\n87\n88\n89\n91\n92\n93\n94\n95\n96\n97\n98\n100\n101\n102\n103\n104\n105\n106\n107\n108\n109\n110\n111\n112\n113\n114\n115\n116\n117\n118\n119\n120\n121\n122\n123\n124\n125\n126\n127\n128\n129\n130\n131\n132\n133\n134\n135\n136\n137\n138\n139\n140\n141\n142\n143\n144\n145\n146\n147\n148\n149\n150\n151\n152\n154\n156\n157\n158\n159\n160\n161\n162\n168\n169\n170\n171\n172\n173\n174\n175\n176\n177\n179\n180\n181\n182\n183\n184\n185\n186\n187\n189\n190\n191\n192\n193\n194\n195\n196\n197\n198\n199\n200\n201\n202\n203\n204\n206\n207\n208\n210\n211\n212\n213\n214\n215\n216\n217\n218\n219\n220\n221\n222\n223\n224\n225\n226\n227\n228\n229\n230\n231\n232\n233\n234\n235\n236\n237\n238\n239\n240\n241\n242\n243\n244\n245\n246\n247\n248\n249\n250\n251\n252\n254\n256\n257\n258\n259\n261\n262\n263\n269\n270\n271\n272\n273\n289\n290\n291\n292\n293\n294\n295\n296\n297\n298\n299"},
    {"path": os.path.join("number", "0"), "content": ""},
    {"path": os.path.join("modeldata", "dutyskin", "construction-worker.txt"), "content": "27\n153\n260"},
    {"path": os.path.join("modeldata", "dutyskin", "firefighter.txt"), "content": "277\n278\n279"},
    {"path": os.path.join("modeldata", "dutyskin", "mechanic.txt"), "content": "50\n8\n42\n268"},
    {"path": os.path.join("modeldata", "dutyskin", "paramedic.txt"), "content": "274\n275\n276\n30\n70"},
    {"path": os.path.join("modeldata", "dutyskin", "police.txt"), "content": "280\n281\n282\n300\n301\n302\n306\n307\n309\n265\n266\n267\n283\n284\n288\n311\n310"},
    {"path": os.path.join("modeldata", "job-feature", "mechanic", "tune", "exhaust.txt"), "content": "1018\n1019\n1020\n1021\n1022"},
    {"path": os.path.join("modeldata", "job-feature", "mechanic", "tune", "scoop.txt"), "content": "1004\n1005\n1006\n1011\n1012"},
    {"path": os.path.join("modeldata", "job-feature", "mechanic", "tune", "spoiler.txt"), "content": "1000\n1001\n1002\n1003\n1014\n1015\n1016\n1023"},
    {"path": os.path.join("modeldata", "job-feature", "mechanic", "tune", "wheel.txt"), "content": "1025 0.0 0.0 50.0\n1073 0.0 0.0 50.0\n1074 0.0 0.0 50.0\n1075 0.0 0.0 50.0\n1076 0.0 0.0 50.0\n1077 0.0 0.0 50.0\n1078 0.0 0.0 50.0\n1079 0.0 0.0 50.0\n1080 0.0 0.0 50.0\n1081 0.0 0.0 50.0\n1082 0.0 0.0 50.0\n1083 0.0 0.0 50.0\n1084 0.0 0.0 50.0\n1085 0.0 0.0 50.0\n1096 0.0 0.0 50.0\n1097 0.0 0.0 50.0\n1098 0.0 0.0 50.0"},
]

if not os.path.isdir("scriptfiles"):
    os.mkdir("scriptfiles")

    if not os.path.isdir(os.path.join("scriptfiles", "player")):
        os.makedirs(os.path.join("scriptfiles", "player"))

        for pdir in PLAYERDIRS:
            if not os.path.isdir(pdir):
                os.makedirs(os.path.join("scriptfiles", "player", pdir))

    if not os.path.isdir(os.path.join("scriptfiles", "server")):
        os.makedirs(os.path.join("scriptfiles", "server"))

        for sdir in SERVERDIRS:
            if not os.path.isdir(sdir):
                os.makedirs(os.path.join("scriptfiles", "server", sdir))

        for sfile in SERVERFILES:
            if not os.path.isfile(sfile['path']):
                open(os.path.join("scriptfiles", "server", sfile['path']), "w").write(sfile['content'])
