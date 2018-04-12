# Unlit/Transparent Bookend Blend

A Unity shader that uses an upper and lower values to cutout the material based off the alpha values from the Base image. There is a blend values that ease the cutout. Also, a black value (0) is always transparent and a white value(255) is always opaque. Color blend gets multiplied to the resulting values.

## Getting Started

Place this shader in your unity project. Add an image to the Base. Play with settings. Recommend turning "Filter Mode" to "Point (no filter)" and no compression on textures.

### Prerequisites

Unity. Tested on 2017.3.1f1

```
Examples
```

### Animating

	private Renderer m_Renderer;
	private Material m_Material;

	void Start() {
		m_Renderer = GetComponent<Renderer>();
		m_Material = m_Renderer.material;
	}

	void Update() {

		float uCutoff = Mathf.PingPong(Time.time, 0.5F)*2f;
		m_Material.SetFloat("_LCutoff", uCutoff);

	}


## Authors

* **Ian Davis** - [idrez](https://github.com/idrez)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Unity Shaders - builtin_shaders-2017.3.1f1

