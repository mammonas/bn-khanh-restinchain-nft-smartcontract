const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();

    const nftContractFactory = await hre.ethers.getContractFactory('RestInChainNFT'); 
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to: ", nftContract.address);

    // let txn = await nftContract.buyNFT("For Someone", "1991-2022", ["Blah blah blah", "Hihi", "hahahahahahahaha", "hahahahahahahahahahaha"]);
    // await txn.wait();
    // txn = await nftContract.updateNFTData(0, "Antony Somebody", "Just something", ["Blah blah blah"]);
    // await txn.wait();
    let txn;
    for (var i = 0; i <= 9; i++) {
        txn = await nftContract.connect(owner).initPlaceHolderNFTs(
            ["Antony Joseph 01" + String(i), "Antony Joseph 02" + String(i), "Antony Joseph 03" + String(i), "Antony Joseph 04" + String(i), "Antony Joseph 05" + String(i)],
            ["20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030"],
            [["Rest in Chain Forever!!!", "Love you as Always!!!"], ["Rest in Chain Forever!!!", "Love you as Always!!!"], ["Rest in Chain Forever!!!", "Love you as Always!!!"], ["Rest in Chain Forever!!!", "Love you as Always!!!"], ["Rest in Chain Forever!!!", "Love you as Always!!!"]]
        );
        await txn.wait();
        console.log("Init done" + String(i));
    }

    let offset = 15;
    let pageToDisplay = 5;

    for (var i = 0; i <= pageToDisplay; i++) {
        txn = await nftContract.getYardNFTByPage(i, offset);
        console.log("NFT Page " + String(i));
        console.log(txn);
    }

    // txn = await nftContract.connect(owner).initPlaceHolderNFTs(
    //     ["Antony Dr. Joseph 16", "Antony Dr. Joseph 17", "Antony Dr. Joseph 18", "Antony Dr. Joseph 19", "Antony Dr. Joseph 20"],
    //     ["20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030"],
    //     ["Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!"]
    // );
    // await txn.wait();
    // console.log("Init done 1");

    // txn = await nftContract.connect(owner).initPlaceHolderNFTs(
    //     ["Antony Dr. Joseph 01", "Antony Dr. Joseph 02", "Antony Dr. Joseph 03", "Antony Dr. Joseph 04", "Antony Dr. Joseph 05"],
    //     ["20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030"],
    //     ["Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!"]
    // );
    // await txn.wait();
    // console.log("Init done 2");

    // txn = await nftContract.connect(owner).initPlaceHolderNFTs(
    //     ["Antony Dr. Joseph 06", "Antony Dr. Joseph 07", "Antony Dr. Joseph 08", "Antony Dr. Joseph 09", "Antony Dr. Joseph 10"],
    //     ["20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030"],
    //     ["Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!"]
    // );
    // await txn.wait();
    // console.log("Init done 3");

    // txn = await nftContract.connect(owner).initPlaceHolderNFTs(
    //     ["Antony Dr. Joseph 11", "Antony Dr. Joseph 12", "Antony Dr. Joseph 13", "Antony Dr. Joseph 14", "Antony Dr. Joseph 15"],
    //     ["20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030", "20/02/2020 - 20/02/3030"],
    //     ["Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!", "Rest in Chain Forever!!!"]
    // );
    // await txn.wait();
    // console.log("Init done 4");

    // txn = await nftContract.getAllNFT(nftContract.address);
    // console.log("All YardNFT");
    // console.log(txn);

    // txn = await nftContract.getAllNFT(owner.address);
    // console.log("All OwnerNFT");
    // console.log(txn);

    // txn = await nftContract.getYardNFTByPage(0, 15);
    // console.log("NFT Page 0");
    // console.log(txn);

    // txn = await nftContract.getYardNFTByPage(1, 15);
    // console.log("NFT Page 1");
    // console.log(txn);

    // txn = await nftContract.getYardNFTByPage(2, 15);
    // console.log("NFT Page 2");
    // console.log(txn);

    // txn = await nftContract.getYardNFTByPage(3, 15);
    // console.log("NFT Page 3");
    // console.log(txn);

    // txn = await nftContract.getYardNFTByPage(4, 15);
    // console.log("NFT Page 4");
    // console.log(txn);

    // txn = await nftContract.getYardNFTByPage(5, 15);
    // console.log("NFT Page 5");
    // console.log(txn);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(0);
    }
};

runMain();