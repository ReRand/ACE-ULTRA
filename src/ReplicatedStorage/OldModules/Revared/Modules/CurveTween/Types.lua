return {
	
	{

		Name = "number", 
		
		Magnitude = function(x: number, y: number)
			return math.sqrt( (x^2) - (y^2) );
		end,

	}, {

		Name = "Vector3", 
		
		Magnitude = function(x: Vector3, y: Vector3)
			return (x - y).Magnitude;
		end,
		
		MidPoint = function(m, x: Vector3, y: Vector3)
			return CFrame.new(x, y) 
				* CFrame.new(0, 0, -m) 
				* CFrame.new(-Random.new():NextNumber(0,m/2), Random.new():NextNumber(0,m/2), 0).Position
		end,

	}, {

		Name = "CFrame", 
		
		Magnitude = function(x: CFrame, y: CFrame)
			return (x.Position - y.Position).Magnitude;
		end,
		
		MidPoint = function(m, x: Vector3, y: Vector3)
			return CFrame.new(x.Position, y.Position) 
				* CFrame.new(0, 0, -m) 
				* CFrame.new(-(Random.new():NextNumber(0,m/2)), Random.new():NextNumber(0, m/2), 0)
		end,

	}, {

		Name = "UDim2", 
		
		Magnitude = function(x: UDim2, y: UDim2)
			return math.sqrt( (x^2) - (y^2) );
		end,
		
	}
	
}