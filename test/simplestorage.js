const SimpleStorage = artifacts.require("./SimpleStorage.sol");

contract("SimpleStorage", accounts => {
  it("It should store the value", async () => {
    // Arrange
    const expected = 89;
    const simpleStorageInstance = await SimpleStorage.deployed();

    // Act
    // Set value
    await simpleStorageInstance.set(expected, { from: accounts[0] });

    // Assert
    // Get stored value
    const actual = await simpleStorageInstance.get.call();
    assert.equal(actual, expected, `The value ${expected} was not stored.`);
  });
});
