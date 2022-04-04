// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BestAdviceGiven is Ownable {
    // struct to represent the BestAdvice object
    struct BestAdvice {
        string text;
        string from;
        string yourAge;
        uint256 version;
    }

    mapping(address => BestAdvice) public bestAdviceGiven;

    uint256 private _totalAdviceGiven;

    event AdviceSaved(address indexed sender, string advice);

    function saveBestAdvice(
        string memory _text,
        string memory _from,
        string memory _yourAge
    ) public {
        require(
            bestAdviceGiven[msg.sender].version < 1,
            "You have already saved your best advice given"
        );

        BestAdvice memory newAdvice = BestAdvice({
            text: _text,
            from: _from,
            yourAge: _yourAge,
            version: 1
        });

        bestAdviceGiven[msg.sender] = newAdvice;

        _totalAdviceGiven += 1;

        emit AdviceSaved(msg.sender, _text);
    }

    function saveBestAdvice(string memory _text, string memory _from) public {
        saveBestAdvice(_text, _from, "Unknown");
    }

    function saveBestAdvice(string memory _text) public {
        saveBestAdvice(_text, "Unknown", "Unknown");
    }

    function getTotalAdviceGiven() public view returns (uint256 _total) {
        return _totalAdviceGiven;
    }

    function editBestAdviceGiven(
        string memory _text,
        string memory _from,
        string memory _yourAge
    ) public payable {
        require(
            msg.value == 0.001 ether,
            "You need to supply 0.001 ether to edit your best advice"
        );

        BestAdvice memory newAdvice = BestAdvice({
            text: _text,
            from: _from,
            yourAge: _yourAge,
            version: bestAdviceGiven[msg.sender].version + 1
        });

        bestAdviceGiven[msg.sender] = newAdvice;
    }

    function withdrawal() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool sent, ) = owner().call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
