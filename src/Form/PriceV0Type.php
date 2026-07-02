<?php

namespace App\Form;

use App\Dto\PriceV0Dto;
use BcMath\Number;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\CallbackTransformer;
use Symfony\Component\Form\Extension\Core\Type\NumberType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class PriceV0Type extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('priceA', NumberType::class, ['label' => 'Price A — GreaterThanOrEqual(new BcMath\\Number("0.01"))']);

        $builder->get('priceA')->addModelTransformer(static::getCallbackTransformer());
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults(['data_class' => PriceV0Dto::class]);
    }

    /**
     * DTO → Form: BcMath\Number → (transform) → float → (NumberType) → show string
     * Form → DTO: entered string → (NumberType) → float → (reverseTransform) → BcMath\Number
     */
    static private function getCallbackTransformer(): CallbackTransformer
    {
        return new CallbackTransformer(
            fn (?Number $value): ?float => null === $value ? null : (float) (string) $value,
            fn (int|float|null $value): ?Number => null === $value ? null : new Number((string) $value),
        );
    }
}
